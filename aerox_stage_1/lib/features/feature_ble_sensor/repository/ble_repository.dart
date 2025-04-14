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
      //toCsvBlob.exportParsedBlobToCsv( parsed, fileName: "${blob.createdAt}" );
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
Future<EitherErr<void>> setTimestamp(RacketSensor sensor, {DateTime? dateTime}) async {
  return EitherCatch.catchAsync<void, BluetoothErr>(() async {
    final now = (dateTime ?? DateTime.now().toUtc());

    // --- TimestampMeasurement encoding (timestamp in seconds + ms) ---
    final int timestampSeconds = now.millisecondsSinceEpoch ~/ 1000;
    final int ms = now.microsecond ~/ 1000;

    final List<int> timestampValue = []
      ..addAll(_toBytes(timestampSeconds, 4))  // uint32 LE
      ..addAll(_toBytes(ms, 2));               // uint16 LE

    // --- CurrentTimeMeasurement encoding (CTS - 2A2B spec) ---
    final int year = now.year;
    final int month = now.month;
    final int day = now.day;
    final int hour = now.hour;
    final int minute = now.minute;
    final int second = now.second;
    final int weekday = now.weekday; // 1 = Monday ... 7 = Sunday
    final int fraction256 = (now.microsecond * 256 ~/ 1000000);
    final int adjustReason = 0;

    final List<int> currentTimeValue = []
      ..addAll(_toBytes(year, 2))   // uint16 year LE
      ..add(month)
      ..add(day)
      ..add(hour)
      ..add(minute)
      ..add(second)
      ..add(weekday)
      ..add(fraction256)
      ..add(adjustReason);

    final services = await sensor.device.discoverServices();

    final timeService = services.firstWhere(
      (s) => s.uuid == Guid(StorageServiceConstants.CURRENT_TIME_SERVICE_UUID),
      orElse: () => throw BluetoothErr(
        errMsg: 'Servicio CTS (1805) no encontrado.',
        statusCode: 404,
      ),
    );

    // --- Escribir tiempo actual a la característica 2A2B (Current Time) ---
    final timeCharacteristic = timeService.characteristics.firstWhere(
      (c) => c.uuid.toString().toLowerCase().contains('2a2b'),
      orElse: () => throw BluetoothErr(
        errMsg: 'Characteristic Current Time (2A2B) no encontrada.',
        statusCode: 404,
      ),
    );

    await timeCharacteristic.write(currentTimeValue, withoutResponse: false);

    // --- Escribir timestamp extendido a la característica personalizada ---
    final timestampCharacteristic = timeService.characteristics.firstWhere(
      (c) => c.uuid == Guid(StorageServiceConstants.TIMESTAMP_CHARACTERISTIC_UUID),
      orElse: () => throw BluetoothErr(
        errMsg: 'Characteristic Timestamp personalizada no encontrada.',
        statusCode: 404,
      ),
    );

    await timestampCharacteristic.write(timestampValue, withoutResponse: false);

    print("\u2705 Hora BLE y timestamp extendido escritos correctamente: $now");
  }, (e) {
    return BluetoothErr(
      errMsg: 'Error al establecer la hora/timestamp: ${e.toString()}',
      statusCode: 500,
    );
  });
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

Future<EitherErr<DateTime>> getTimestamp(RacketSensor sensor) async {
  return EitherCatch.catchAsync<DateTime, BluetoothErr>(() async {
    final services = await sensor.device.discoverServices();

    final timeService = services.firstWhere(
      (s) => s.uuid == Guid(StorageServiceConstants.CURRENT_TIME_SERVICE_UUID),
      orElse: () => throw BluetoothErr(
        errMsg: 'Servicio CTS (1805) no encontrado.',
        statusCode: 404,
      ),
    );

    final timestampCharacteristic = timeService.characteristics.firstWhere(
      (c) => c.uuid == Guid(StorageServiceConstants.TIMESTAMP_CHARACTERISTIC_UUID),
      orElse: () => throw BluetoothErr(
        errMsg: 'Characteristic Timestamp personalizada no encontrada.',
        statusCode: 404,
      ),
    );

    final value = await timestampCharacteristic.read();
    if (value.length < 6) {
      throw BluetoothErr(errMsg: 'Valor de timestamp inválido.', statusCode: 400);
    }

    final int seconds = value[0] |
        (value[1] << 8) |
        (value[2] << 16) |
        (value[3] << 24);
    final int ms = value[4] | (value[5] << 8);

    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      (seconds * 1000) + ms,
      isUtc: true,
    );

    print("\uD83D\uDCC5 Timestamp leído: $dateTime ($ms ms)");
    return dateTime;
  }, (e) {
    return BluetoothErr(
      errMsg: 'Error al leer el timestamp: ${e.toString()}',
      statusCode: 500,
    );
  });
}

List<int> _toBytes(int value, int length) {
  final result = <int>[];
  for (int i = 0; i < length; i++) {
    result.add((value >> (8 * i)) & 0xFF);
  }
  return result;
}

}