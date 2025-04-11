import 'dart:async';
import 'dart:typed_data';
import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/blob_data_extension.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/ble_service.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/storage_service_constants.dart';

class StorageServiceController {
  final BleService bleService;
  final Map<String, List<Blob>> _devicesBlobs = {};

  StorageServiceController({required this.bleService});

  Future<EitherErr<List<Blob>>> getBlobs(BluetoothDevice device) {
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

    if (blobInfo is BlobInfo) {
      final packetResult = await fetchBlobPacketsFast(device, fetchPacketData: fetchData);
      final packets = packetResult.getOrElse(() => []);
      final blob = Blob(blobInfo: blobInfo as BlobInfo, packets: packets);
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

Future<EitherErr<List<int>>> fetchBlobPacketData(
  BluetoothDevice device,
  BlobPacket packet,
) {
  if (packet.packetInfo == null) {
    return Future.value(
      Left(BluetoothErr(errMsg: "PacketInfo is null", statusCode: 103)),
    );
  }

  final headerSize = packet.packetInfo!.dataAddress - packet.packetInfo!.address;
  final dataSize = packet.packetInfo!.packetSize - headerSize;

  return readRangeData(device, packet.packetInfo!.dataAddress, dataSize)
      .flatMap((data) async {
        return Right(data.toList()); // si necesitas convertir a List<int>
      });
}

Future<EitherErr<Uint8List>> readRangeData(
  BluetoothDevice device,
  int startAddress,
  int dataLen,
) async {
  var readAddress = startAddress;
  var bytesToRead = dataLen;
  final rawData = BytesBuilder();

  Future<EitherErr<void>> readNextChunk() async {
    final chunkSize = bytesToRead > StorageServiceConstants.STORAGE_MAX_DATA_LEN
        ? StorageServiceConstants.STORAGE_MAX_DATA_LEN
        : bytesToRead;

    return readData(device, readAddress, chunkSize).flatMap((data) async {
      rawData.add(data);
      bytesToRead -= chunkSize;
      readAddress += chunkSize;
      return Right(null);
    });
  }

  int retryCount = 0;

  while (bytesToRead > 0) {
    final result = await readNextChunk();
    if (result is Right) {
      retryCount = 0;
    } else {
      retryCount++;
      if (retryCount < 3) {
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        final err = (result as Left).value;
        return Left(err);
      }
    }
  }

  return Right(rawData.toBytes());
}

Future<Either<Err, List<BlobPacket>>> fetchBlobPackets(
  BluetoothDevice device, {
  bool fetchPacketData = false,
}) {
  return fetchFirstPacket(device).flatMap((firstPacket) async {
    final packets = <BlobPacket>[];
    PacketInfo? currentPacket = firstPacket;

    while (currentPacket != null) {
      final packet = BlobPacket(packetInfo: currentPacket);

      if (fetchPacketData) {
        final eitherData = await fetchBlobPacketData(device, packet);
        if (eitherData is Left) {
          final err = (eitherData as Left).value;
          return Left(err);
        }
        packet.packetData = (eitherData as Right).value;
      }

      packets.add(packet);

      final nextEither = await fetchNextPacket(device);
      if (nextEither is Left) {
        final err = (nextEither as Left).value;
        if (err.statusCode == 204) {
          break; // fin de blobs
        } else {
          return Left(err);
        }
      }

      currentPacket = (nextEither as Right).value;
    }

    return Right(packets);
  });
}


    Future<EitherErr<Uint8List>> readData(BluetoothDevice device, int address, int dataLen) {
    final cmd = BytesBuilder()
      ..addByte(StorageServiceConstants.STORAGE_CP_OP_READ_DATA)
      ..add(_intTo3Bytes(address))
      ..addByte(dataLen);

    return bleService
        .sendCommand(
          device: device,
          serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
          characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
          cmd: cmd.toBytes(),
        )
        .flatMap((response) async {
          if (response.length < 3) {
            return Left(BluetoothErr(errMsg: "Invalid response from readData", statusCode: 201));
          }
          return Right(Uint8List.fromList(response.sublist(2))); // skip opcode & status
        });
}
  Future<EitherErr<int>> writeData(BluetoothDevice device, int address, Uint8List data) {
    final cmd = BytesBuilder()
      ..addByte(StorageServiceConstants.STORAGE_CP_OP_WRITE_DATA)
      ..add(_intTo3Bytes(address))
      ..add(data);

    return bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: cmd.toBytes(),
    ).flatMap((response) async {
      if (response.length < 3) {
        return Left(BluetoothErr(errMsg: "Response too short", statusCode: 202));
      }
      return Right(response[2]);
    });
  }



Future<EitherErr<BlobInfo>> fetchFirstBlob(BluetoothDevice device) {
  return bleService.sendCommand(
    device: device,
    serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
    characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
    cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_FIRST_BLOB],
  ).flatMap((response) async {
    final info = response.toBlobInfo();
    if (info == null) {
      return Left(BluetoothErr(errMsg: 'Invalid BlobInfo response', statusCode: 203));
    }
    return Right(info);
  });
}

Future<EitherErr<BlobInfo>> fetchNextBlob(BluetoothDevice device, [int numBlobs = 1]) {
  return bleService.sendCommand(
    device: device,
    serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
    characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
    cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_NEXT_BLOB, numBlobs],
  ).flatMap((response) async {
    final info = response.toBlobInfo();
    if (info == null) {
      return Left(BluetoothErr(errMsg: 'Invalid BlobInfo response', statusCode: 204));
    }
    return Right(info);
  });
}

Future<EitherErr<PacketInfo>> fetchFirstPacket(BluetoothDevice device) {
  return bleService.sendCommand(
    device: device,
    serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
    characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
    cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_FIRST_PACKET],
  ).flatMap((response) {
    if (response.length < 3) {
      return Future.value(
        Left(BluetoothErr(errMsg: 'Response too short for PacketInfo', statusCode: 205)),
      );
    }

    final packetInfo = PacketInfo.fromRaw(response.sublist(2));
    return Future.value(Right(packetInfo!));
  });
}

  Future<EitherErr<PacketInfo>> fetchNextPacket(BluetoothDevice device, [int numPackets = 1]) {
    return bleService.sendCommand(
      device: device,
      serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
      characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
      cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_NEXT_PACKET, numPackets],
    ).flatMap((response) async {
      final info = response.toPacketInfo();
      if (info == null) {
        return Left(BluetoothErr(errMsg: 'Invalid PacketInfo response', statusCode: 206));
      }
      return Right(info);
    });
  }

Future<EitherErr<int>> getNumBlobs(BluetoothDevice device) {
  return bleService.sendCommand(
    device: device,
    serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
    characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
    cmd: [StorageServiceConstants.STORAGE_CP_OP_GET_NUM_BLOBS],
  ).flatMap((response) async {
    if (response.length < 3) {
      return Left(BluetoothErr(errMsg: 'Response too short to get num blobs', statusCode: 207));
    }
    return Right(response[2]);
  });
}

Future<EitherErr<List<PacketInfo>>> fetchAllPacketInfos(BluetoothDevice device) async {
  return fetchFirstPacket(device).flatMap((first) async {
    final allPackets = <PacketInfo>[first];

    while (true) {
      final eitherResponse = await bleService.sendCommand(
        device: device,
        serviceUuid: Guid(StorageServiceConstants.STORAGE_SERVICE_UUID),
        characteristicUuid: Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID),
        cmd: [StorageServiceConstants.STORAGE_CP_OP_FETCH_NEXT_PACKET, 255],
      );

      final handled = await eitherResponse.flatMap((response) async {
        if (response.length < 2) {
          return Left(BluetoothErr(errMsg: 'Incomplete response while fetching packets', statusCode: 207));
        }

        final packetInfos = PacketInfo.fromMultipleRaw(response.sublist(2));
        if (packetInfos.isEmpty) {
          return Left(BluetoothErr(errMsg: 'No more packets available', statusCode: 208));
        }

        allPackets.addAll(packetInfos);

        if (packetInfos.length < 255) {
          // Si no se llenó el lote, terminamos
          return Right(allPackets);
        }

        // Continuamos buscando más
        return Right(null);
      } as Function1<List<int>, Either<Err, dynamic>>);

      if (handled.isLeft() || handled.getOrElse(() => null) != null) break;
    }

    return Right(allPackets);
  });
}
Future<Either<Err, List<BlobPacket>>> fetchBlobPacketsFast(BluetoothDevice device, {bool fetchPacketData = false}) {
  return fetchAllPacketInfos(device).flatMap((packetInfos) async {
    final packets = <BlobPacket>[];

    for (final packetInfo in packetInfos) {
      final packet = BlobPacket(packetInfo: packetInfo);

      if (fetchPacketData) {
        final eitherData = await fetchBlobPacketData(device, packet);
        eitherData.fold(
          (l) => null, // podrías loguearlo si quieres
          (data) => packet.packetData = data,
        );
      }

      packets.add(packet);
    }

    return Right(packets);
  });
}

  Uint8List _intTo3Bytes(int value) {
    return Uint8List(3)
      ..[0] = value & 0xFF
      ..[1] = (value >> 8) & 0xFF
      ..[2] = (value >> 16) & 0xFF;
  }
}
