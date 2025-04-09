import 'dart:async';
import 'dart:typed_data';
import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob_data_extension.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/ble_service.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/storage_service_constants.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';


class StorageServiceController {
  final BleService bleService;
  final Map<String, List<Blob>> _devicesBlobs = {};

  StorageServiceController({required this.bleService});

  Future<EitherErr<List<Blob>>> getBlobs(BluetoothDevice device) async {
    return EitherCatch.catchAsync<List<Blob>, BluetoothErr>(() async {
      final blobs = _devicesBlobs[device.remoteId.str] ?? await fetchBlobs(device);
      return blobs ?? [];
    }, (e) => BluetoothErr(errMsg: e.toString(), statusCode: 101));
  }

  Future<List<Blob>?> fetchBlobs(BluetoothDevice device, {bool fetchData = false}) async {
    final numBlobs = await getNumBlobs(device);
    if (numBlobs == null || numBlobs == 0) return [];

    final blobs = <Blob>[];
    var blobInfo = await fetchFirstBlob(device);

    while (blobInfo != null) {
      final packets = await fetchBlobPacketsFast(device, fetchPacketData: fetchData);
      final blob = Blob(blobInfo: blobInfo, packets: packets);
      if (packets.isNotEmpty) {
        blob.createdAt = packets.first.packetInfo?.createdAt;
        blob.closedAt = packets.last.packetInfo?.closedAt;
      }
      blobs.add(blob);
      blobInfo = await fetchNextBlob(device);
    }

    _devicesBlobs[device.remoteId.str] = blobs;
    return blobs;
  }

  Future<void> fetchBlobData(BluetoothDevice device, Blob blob) async {
    for (final packet in blob.packets) {
      packet.packetData = await fetchBlobPacketData(device, packet);
    }
  }

  Future<List<int>?> fetchBlobPacketData(BluetoothDevice device, BlobPacket packet) async {
    if (packet.packetInfo == null) return null;
    final headerSize = packet.packetInfo!.dataAddress - packet.packetInfo!.address;
    final dataSize = packet.packetInfo!.packetSize - headerSize;
    return _readRangeData(device, packet.packetInfo!.dataAddress, dataSize) ?? null;
  }

  Future<Uint8List?> _readRangeData(BluetoothDevice device, int startAddress, int dataLen) async {
    var readAddress = startAddress;
    var bytesToRead = dataLen;
    var rawData = BytesBuilder();
    var retryCount = 0;

    while (bytesToRead > 0) {
      final chunkSize = bytesToRead > StorageServiceConstants.STORAGE_MAX_DATA_LEN 
          ? StorageServiceConstants.STORAGE_MAX_DATA_LEN 
          : bytesToRead;

      var data = await readData(device, readAddress, chunkSize);
      if (data != null) {
        rawData.add(data);
        bytesToRead -= chunkSize;
        readAddress += chunkSize;
        retryCount = 0;
      } else if (retryCount < 3) {
        retryCount++;
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        return null;
      }
    }
    return rawData.toBytes();
  }

  Future<Either<Err, List<BlobPacket>>> fetchBlobPackets(BluetoothDevice device, {bool fetchPacketData = false}) {
    return EitherCatch.catchAsync<List<BlobPacket>, BluetoothErr>(() async {
      final packets = <BlobPacket>[];
      var packetInfo = await fetchFirstPacket(device);

      while (packetInfo != null) {
        final packet = BlobPacket(packetInfo: packetInfo);
        if (fetchPacketData) {
          packet.packetData = await fetchBlobPacketData(device, packet);
        }
        packets.add(packet);
        packetInfo = await fetchNextPacket(device);
      }

      return packets;
    }, (e) => BluetoothErr(errMsg: e.toString(), statusCode: 103));
  }

  Future<Uint8List?> readData(BluetoothDevice device, int address, int dataLen) async {
    final cmd = BytesBuilder()
      ..addByte(StorageServiceConstants.STORAGE_CP_OP_READ_DATA)
      ..add(_intTo3Bytes(address))
      ..addByte(dataLen);

    final response = await bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: cmd.toBytes(),
    );

    if (response != null) {
      return Uint8List.fromList(response.sublist(2)); // Skip opcode and status
    }
    return null;
  }

  Future<int?> writeData(BluetoothDevice device, int address, Uint8List data) async {
    final cmd = BytesBuilder()
      ..addByte(StorageServiceConstants.STORAGE_CP_OP_WRITE_DATA)
      ..add(_intTo3Bytes(address))
      ..add(data);

    final response = await bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: cmd.toBytes(),
    );

    return response?[2]; // Return write status
  }

  Future<BlobInfo?> fetchFirstBlob(BluetoothDevice device) async {
    final response = await bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_FIRST_BLOB],
    );
    return response?.toBlobInfo();
  }

  Future<BlobInfo?> fetchNextBlob(BluetoothDevice device, [int numBlobs = 1]) async {
    final response = await bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_NEXT_BLOB, numBlobs],
    );
    return response?.toBlobInfo();
  }

  Future<PacketInfo?> fetchFirstPacket(BluetoothDevice device) async {
    final response = await bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_FIRST_PACKET],
    );
    return PacketInfo.fromRaw(response!.sublist(2));
  }

  Future<PacketInfo?> fetchNextPacket(BluetoothDevice device, [int numPackets = 1]) async {
    final response = await bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_NEXT_PACKET, numPackets],
    );
    return response?.toPacketInfo();
  }

  Future<int?> getNumBlobs(BluetoothDevice device) async {
    final response = await bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: [StorageServiceConstants.STORAGE_CP_OP_GET_NUM_BLOBS],
    );
    return response?[2]; // [opcode, status, num_blobs]
  }

  Future<List<PacketInfo>> fetchAllPacketInfos(BluetoothDevice device) async {
    final first = await fetchFirstPacket(device);
    if (first == null) return [];

    final allPackets = <PacketInfo>[first];

    while (true) {
      final response = await bleService.sendCommand(
        device: device,
        serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
        characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
        cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_NEXT_PACKET, 255],
      );

      if (response == null || response.length < 2) break;

      final packetInfos = PacketInfo.fromMultipleRaw(response.sublist(2));
      if (packetInfos.isEmpty) break;

      allPackets.addAll(packetInfos);
      if (packetInfos.length < 255) break;
    }

    return allPackets;
  }

  Future<List<BlobPacket>> fetchBlobPacketsFast(BluetoothDevice device, {bool fetchPacketData = false}) async {
    final packetInfos = await fetchAllPacketInfos(device);

    final packets = <BlobPacket>[];

    for (final packetInfo in packetInfos) {
      final packet = BlobPacket(packetInfo: packetInfo);
      if (fetchPacketData) {
        packet.packetData = await fetchBlobPacketData(device, packet);
      }
      packets.add(packet);
    }

    return packets;
  }

  Uint8List _intTo3Bytes(int value) {
    return Uint8List(3)
      ..[0] = value & 0xFF
      ..[1] = (value >> 8) & 0xFF
      ..[2] = (value >> 16) & 0xFF;
  }
}
