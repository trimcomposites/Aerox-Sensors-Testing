import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/blob_data_extension.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/blob_data_parser.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/ble_service.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/to_csv_blob.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/storage_service_constants.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/storage_service_controller.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleRepository {
  final BleService bleService;
  final StorageServiceController storageServiceController;
  final BlobDataParser blobDataParser;
  final ToCsvBlob toCsvBlob;
  BleRepository({
    required this.bleService, 
    required this.storageServiceController, 
    required this.blobDataParser,
    required this.toCsvBlob
    });

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
      0x03,         
      0x03,      
      0x03,     
      0x06,      
      0x05           
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
      final blobs = await storageServiceController.fetchBlobs(sensor.device, fetchData: true);
      return Right(blobs ?? []);
    } catch (e) {
      return Left(BluetoothErr(errMsg: e.toString(), statusCode: 99));
    }
  }


Future<EitherErr<List<Map<String, dynamic>>>> parseBlob(Blob blob) async {
  try {
    final blobType = blob.blobInfo.blobType;

    if (blobType == StorageServiceConstants.HS_RTSOS_BLOB_REGISTER_TYPE) {
      final parsed = blobDataParser.parseHsRtsosBlob(blob);
      return Right(parsed);
    }

    if (blobType == StorageServiceConstants.HS_1KHZ_RTSOS_BLOB_REGISTER_TYPE) {
      final parsed = blobDataParser.parseHs1kzRtsosBlob(blob);
      print( " PARSED BLOB: ${parsed} " );
      toCsvBlob.exportParsedBlobToCsv( parsed, fileName: "${blob.createdAt}" );
      return Right(parsed);
    }

    return Left(BluetoothErr(
      errMsg: 'Unsupported blob type: $blobType',
      statusCode: 98,
    ));
  } catch (e) {
    return Left(BluetoothErr(
      errMsg: e.toString(),
      statusCode: 99,
    ));
  }
}
Future<EitherErr<void>> eraseAllBlobs(RacketSensor sensor) {
  final serviceUuid = Guid(StorageServiceConstants.STORAGE_SERVICE_UUID);
  final characteristicUuid = Guid(StorageServiceConstants.STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID);
  const eraseCommand = [StorageServiceConstants.STORAGE_CP_OP_ERASE_MEMORY];

  return bleService
      .sendCommand(
        device: sensor.device,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
        cmd: eraseCommand,
      )
      .flatMap((response) async {
        if (response.length < 2 || response[1] != 0) {
          return Left(BluetoothErr(
            errMsg: 'Failed to erase memory. Response: $response',
            statusCode: 97,
          ));
        }
        return Right(null);
      });
}

}