import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/blob_data_extension.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/ble_service.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/storage_service_constants.dart';

class StorageServiceController {
  final BleService bleService;
  final Map<String, List<Blob>> _devicesBlobs = {};

  StorageServiceController({required this.bleService});

  Future<List<Blob>> getBlobs(BluetoothDevice device) async {
    return _devicesBlobs[device.remoteId.str] ?? await fetchBlobs(device);
  }

  Future<List<Blob>> fetchBlobs(BluetoothDevice device, {bool fetchData = false}) async {
    final numBlobs = await getNumBlobs(device);
    if (numBlobs == null || numBlobs == 0) return [];

    final blobs = <Blob>[];
    BlobInfo? blobInfo = await fetchFirstBlob(device);

    while (blobInfo != null || numBlobs < blobs.length ) {
      final packets = await fetchBlobPacketsFast(device, fetchPacketData: fetchData);
      final blob = Blob(blobInfo: blobInfo!, packets: packets);
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

Future<List<int>> fetchBlobPacketData(BluetoothDevice device, BlobPacket packet) async {
  if (packet.packetInfo == null) {
    throw Exception("PacketInfo is null");
  }

  final headerSize = packet.packetInfo!.dataAddress - packet.packetInfo!.address;
  final dataSize = packet.packetInfo!.packetSize - headerSize;
  final data = await readRangeDataAsPython(
    device: device,
    serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
    characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
    startAddress: packet.packetInfo!.dataAddress,
    dataLen: dataSize,
  );

  return data.toList();
}


Future<Uint8List> readRangeDataAsPython({
  required BluetoothDevice device,
  required Guid serviceUuid,
  required Guid characteristicUuid,
  required int startAddress,
  required int dataLen,
  int maxChunkSize = 240,
  Duration timeout = const Duration(seconds: 4),
}) async {
  final services = await device.discoverServices();
  final service = services.firstWhere((s) => s.uuid == serviceUuid);
  final characteristic = service.characteristics.firstWhere((c) => c.uuid == characteristicUuid);

  final rawData = BytesBuilder();
  int totalReceived = 0;
  final completer = Completer<Uint8List>();

  late final StreamSubscription<List<int>> subscription;
  await characteristic.setNotifyValue(true);

  subscription = characteristic.value.listen((value) async {
    if (value.isNotEmpty && value[0] == StorageServiceConstants.STORAGE_CP_OP_READ_DATA) {
      final payload = value.skip(2);
      rawData.add(Uint8List.fromList(payload.toList()));
      totalReceived += payload.length;

      if (totalReceived >= dataLen && !completer.isCompleted) {
        await subscription.cancel();
        await characteristic.setNotifyValue(false);
        final result = rawData.toBytes().sublist(3); // ⬅️ CORTAMOS EXACTAMENTE
        completer.complete(result);
      }
    }
  });

  final numChunks = (dataLen / maxChunkSize).ceil();

  for (var i = 0; i < numChunks; i++) {
    final chunkAddress = startAddress + i * maxChunkSize;
    final chunkLen = (i == numChunks - 1)
        ? dataLen - (i * maxChunkSize)
        : maxChunkSize;

    final cmd = [
      StorageServiceConstants.STORAGE_CP_OP_READ_DATA,
      ...chunkAddress.toBytesLE(length: 3),
      chunkLen
    ];

    await characteristic.write(cmd, withoutResponse: false);
    await Future.delayed(const Duration(milliseconds: 10)); // ajustable si hace falta
  }

  final result = await completer.future;

  // Seguridad por si no se cumplió el if dentro del listener
  if (!completer.isCompleted) {
    await subscription.cancel();
    await characteristic.setNotifyValue(false);
    completer.complete(rawData.toBytes().sublist(0, dataLen));
  }

  print( 'result ${result }' );
  print( 'rawData ${result }' );

  return result;
}


  Future<Uint8List> readData(BluetoothDevice device, int address, int dataLen) async {
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

    if (response.length < 3) {
      throw Exception("Invalid response from readData");
    }
    return Uint8List.fromList(response.sublist(2));
  }

  Future<int> writeData(BluetoothDevice device, int address, Uint8List data) async {
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

    if (response.length < 3) {
      throw Exception("Response too short");
    }
    return response[2];
  }

  Future<BlobInfo?> fetchFirstBlob(BluetoothDevice device) async {
    final response = await bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_FIRST_BLOB],
    );
    return response.toBlobInfo();
  }

  Future<BlobInfo?> fetchNextBlob(BluetoothDevice device, [int numBlobs = 1]) async {
    try{
      final response = await bleService.sendCommand(
        device: device,
        serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
        characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
        cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_NEXT_BLOB, numBlobs],
      );
      return response.toBlobInfo();
    }catch (e){
      return null;
    }

  }

  Future<PacketInfo> fetchFirstPacket(BluetoothDevice device) async {
    final response = await bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_FIRST_PACKET],
    );

    if (response.length < 3) {
      throw Exception('Response too short for PacketInfo');
    }

    return PacketInfo.fromRaw(response.sublist(2))!;
  }

  Future<PacketInfo> fetchNextPacket(BluetoothDevice device, [int numPackets = 1]) async {
    final response = await bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_NEXT_PACKET, numPackets],
    );
    return response.toPacketInfo()!;
  }

  Future<int?> getNumBlobs(BluetoothDevice device) async {
    final response = await bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: [StorageServiceConstants.STORAGE_CP_OP_GET_NUM_BLOBS],
    );
    return response.length >= 3 ? response[2] : null;
  }
Future<List<PacketInfo>> fetchAllPacketInfos(BluetoothDevice device) async {
  final allPackets = <PacketInfo>[];

  final first = await fetchFirstPacket(device);
  allPackets.add(first);

  while (true) {
    try {
      final responses = await bleService.sendCommandAndCollectMultiple(
        device: device,
        serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
        characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
        cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_NEXT_PACKET, 255],
        isValidResponse: (value) =>
            value.isNotEmpty && value[0] == StorageServiceConstants.STORAGE_CP_OP_FETCH_NEXT_PACKET,
        maxResponses: 255, // Permitir que lleguen muchos de golpe
        timeout: const Duration(milliseconds: 800), // Ajustar según rendimiento BLE
      );

      if (responses.isEmpty) break;

      final rawBytes = responses.expand((e) => e.skip(2)).toList();
      final packetInfos = PacketInfo.fromMultipleRaw(rawBytes);

      if (packetInfos.isEmpty) break;

      allPackets.addAll(packetInfos);

      if (packetInfos.length < 255) break;

    } catch (e) {
      print("⚠️ Error during packet collection: $e");
      break;
    }
  }

  return allPackets;
}

  Future<List<BlobPacket>> fetchBlobPacketsFast(BluetoothDevice device, {bool fetchPacketData = false}) async {
    final packetInfos = await fetchAllPacketInfos(device);
    final packets = <BlobPacket>[];

    for (final packetInfo in packetInfos) {
      final packet = BlobPacket(packetInfo: packetInfo);

      if (fetchPacketData) {
        try {
          final data = await fetchBlobPacketData(device, packet);
          packet.packetData = data;
        } catch (_) {}
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
}extension on int {
  List<int> toBytesLE({int length = 4}) {
    return List.generate(length, (i) => (this >> (8 * i)) & 0xFF);
  }
}
