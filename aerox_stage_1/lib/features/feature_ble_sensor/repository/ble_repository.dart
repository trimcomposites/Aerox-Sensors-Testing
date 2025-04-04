import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/blob_data_extension.dart';
import 'package:aerox_stage_1/domain/models/blob_extension.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/ble_service.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleRepository {
  final BleService bleService;

  BleRepository({required this.bleService});

  Future<EitherErr<void>> sendStartOfflineRSTOS(RacketSensor sensor) async {
    final serviceUuid = Guid('71d713ef-799e-42af-9d57-9803e36b0f93');
    final characteristicUuid = Guid('a84ce035-60ed-4b24-99c9-8683052aa48b');

    final commandCode = 0x22;
    final sampleRate = 0x68;
    final inactivityTimeout = 0x0A;
    int sampleRateData = 0;

    if (sampleRate == 1) {
      sampleRateData = 0;
    } else if (sampleRate == 0x68) {
      sampleRateData = 4;
    }

    final cmd = [
      commandCode,
      sampleRateData,
      1,
      6,
      6,
      inactivityTimeout
    ];

    await bleService.sendCommand(
      device: sensor.device,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      cmd: cmd
    );

    return Right(null);
  }
  Future<EitherErr<void>> sendStartStreamRSTOS(RacketSensor sensor) async {
    final serviceUuid = Guid('93a72a53-fa2a-11e7-8c3f-9a214cf093ae');
    final characteristicUuid = Guid("93a72a53-fa2a-11e7-8c3f-9a214cf093ae");
    final services = await sensor.device.discoverServices();
      final service = services.firstWhere(
        (s) => s.uuid == serviceUuid,
      );

      final characteristic = service.characteristics.firstWhere(
        (c) => c.uuid == characteristicUuid,
      );
      print(characteristic);

    await bleService.subscribeToCharacteristic(characteristic, closeAfterFirst: false, expectedOpcode: 123123123);

    return Right(null);
  }

  Future<EitherErr<void>> sendStopOfflineRSTOS(RacketSensor sensor) async {
    final serviceUuid = Guid('71d713ef-799e-42af-9d57-9803e36b0f93');
    final characteristicUuid = Guid('a84ce035-60ed-4b24-99c9-8683052aa48b');

    await bleService.sendCommand(
      device: sensor.device,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      cmd: [0x24]
    );

    return Right(null);
  }
Future<EitherErr<List<Blob>>> readAllBlobs(RacketSensor sensor) async {
  try {
    final serviceUuid = Guid('71d713ef-799e-42af-9d57-9803e36b0f93');
    final characteristicUuid = Guid('a84ce035-60ed-4b24-99c9-8683052aa48b');

    final numBlobsResp = await getBlobNumber(sensor, serviceUuid, characteristicUuid);
    if (numBlobsResp == null || numBlobsResp.length < 3 || numBlobsResp.first != 0x09) {
      return Left(BluetoothErr(errMsg: "Error leyendo número de blobs", statusCode: 2));
    }

    final numBlobs = numBlobsResp[2];
    if (numBlobs == 0) return Right([]);

    final allBlobs = <Blob>[];

    for (int i = 0; i < numBlobs; i++) {
      final selectBlobCmd = (i == 0) ? [0x03] : [0x04, 0x01];
      final blobHeaderRaw = await bleService.sendCommand(
        device: sensor.device,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
        cmd: selectBlobCmd,
        closeAfterResponse: false,
      );

      if (blobHeaderRaw == null) break;

      final blobHeader = blobHeaderRaw.toPacketInfo();
      if (blobHeader == null) continue;

      final data = await _readPacketData(sensor: sensor, packetInfo: blobHeader);
      if (data == null) continue;

      allBlobs.add(Blob(
        packetInfo: blobHeader,
        packetData: data,
      ));
    }

    return Right(allBlobs);
  } catch (e) {
    print("Error reading all blobs: $e");
    return Left(BluetoothErr(errMsg: e.toString(), statusCode: 99));
  }
}
Future<List<int>?> _readPacketData({
  required RacketSensor sensor,
  required PacketInfo packetInfo,
}) async {
  try {
    final serviceUuid = Guid('71d713ef-799e-42af-9d57-9803e36b0f93');
    final characteristicUuid = Guid('a84ce035-60ed-4b24-99c9-8683052aa48b');

    final address = packetInfo.dataAddress;
    final length = packetInfo.dataSize;

    final addressBytes = [
      address & 0xFF,
      (address >> 8) & 0xFF,
      (address >> 16) & 0xFF,
    ];

    final cmd = [0x01, ...addressBytes, length];

    final rawData = await bleService.sendCommand(
      device: sensor.device,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      cmd: cmd,
      requireStatusOk: true,
    );

    if (rawData == null || rawData.length < 2) return null;

    // Exclude opcode and status (first 2 bytes)
    return rawData.sublist(2);
  } catch (e) {
    print("Error reading packet data: $e");
    return null;
  }
}


  Future<List<int>?> getBlobNumber(RacketSensor sensor, Guid serviceUuid, Guid characteristicUuid) {
    return bleService.sendCommand(
      device: sensor.device,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      cmd: [9], 
    );
  }


}


