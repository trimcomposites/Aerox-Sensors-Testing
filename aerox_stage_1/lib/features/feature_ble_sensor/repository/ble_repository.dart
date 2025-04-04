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

      if (numBlobsResp == null || numBlobsResp.isEmpty || numBlobsResp.first != 0x09) {
        return Left(BluetoothErr(errMsg: "Error leyendo número de blobs", statusCode: 2));
      }

      final numBlobs = numBlobsResp[2]; 

      if (numBlobs == 0) return Right([]);

      List<Blob> allBlobResponses = [];

      // RECOGER PRIMER BLOBS
      final firstBlob = await bleService.sendCommand(
        device: sensor.device,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
        cmd: [0x03], // STORAGE_CP_OP_FETCH_FIRST_BLOB
        closeAfterResponse: false
      );
      if (firstBlob != null) {
        final blob = await firstBlob.toBlob();
          if (blob != null) {
            allBlobResponses.add(blob);
          }

      }

      // TODOS LOS BLOBS RESTANTES 
      for (int i = 1; i < numBlobs; i++) {
        final nextBlob = await bleService.sendCommand(
          device: sensor.device,
          serviceUuid: serviceUuid,
          characteristicUuid: characteristicUuid,
          cmd: [0x04, 0x01], // STORAGE_CP_OP_FETCH_NEXT_BLOB, 1
        );
        if (nextBlob == null) break;
        final blob = await nextBlob.toBlob();
        if (blob != null) {
          allBlobResponses.add(blob);
        }
      }
      print( 'all blobs: ${allBlobResponses}' );
      return Right(allBlobResponses);
    } catch (e) {
      print("Error reading blobs: $e");
      return Left(BluetoothErr(errMsg: e.toString(), statusCode: 1));
    }
  }




Future<EitherErr<List<BlobPacket>>> fetchBlobPackets(RacketSensor sensor) async {
  try {
    var serviceUuid = Guid('71d713ef-799e-42af-9d57-9803e36b0f93');
    var characteristicUuid = Guid('a84ce035-60ed-4b24-99c9-8683052aa48b');

    final packets = <BlobPacket>[];

    final firstPacketRaw = await bleService.sendCommand(
      device: sensor.device,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      cmd: [0x05], // STORAGE_CP_OP_FETCH_FIRST_PACKET
      closeAfterResponse: false,
      requireStatusOk: false
    );

    if (firstPacketRaw == null || firstPacketRaw.isEmpty) {
      return Left(BluetoothErr(errMsg: "No se recibió el primer paquete", statusCode: 10));
    }

    final firstInfo = firstPacketRaw.toPacketInfo();
    if (firstInfo == null) {
      return Left(BluetoothErr(errMsg: "Error parseando el primer paquete", statusCode: 11));
    }

    packets.add(BlobPacket(packetInfo: firstInfo, packetData: const []));


    while (true) {
      final nextPacketRaw = await bleService.sendCommand(
        device: sensor.device,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
        cmd: [0x06, 0x01], 
        requireStatusOk: false
        
      );

      if (nextPacketRaw == null || nextPacketRaw.length < 15) break;

      final nextInfo = nextPacketRaw.toPacketInfo();
      if (nextInfo == null) break;

      packets.add(BlobPacket(packetInfo: nextInfo, packetData: const []));
    }

    return Right(packets);
  } catch (e) {
    return Left(BluetoothErr(errMsg: e.toString(), statusCode: 99));
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


