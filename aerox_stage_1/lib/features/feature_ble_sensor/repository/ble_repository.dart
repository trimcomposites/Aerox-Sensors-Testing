import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/blob_data_extension.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/blob_data_parser.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/ble_service.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/to_csv_blob.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/storage_service_constants.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/storage_service_controller.dart';

import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_service.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/repository/local/blobs_sqlite_db.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleRepository {
  final BleService bleService;
  final StorageServiceController storageServiceController;
  final BlobDataParser blobDataParser;
  final ToCsvBlob toCsvBlob;
  final BlobSQLiteDB blobSqliteDB;

  BleRepository({
    required this.bleService,
    required this.storageServiceController,
    required this.blobDataParser,
    required this.toCsvBlob,
    required this.blobSqliteDB,
  });

  Future<EitherErr<void>> sendStartOfflineRSTOS(StartRTSOSParams params, ) async {
    final serviceUuid = Guid('71d713ef-799e-42af-9d57-9803e36b0f93');
    final characteristicUuid = Guid('a84ce035-60ed-4b24-99c9-8683052aa48b');
    var cmd;
    final commandCode = 0x22;
    switch( params.sampleRate ){

      case SampleRate.khz1:
        cmd = [commandCode, 0x00, 0x01, 0x06, 0x06, params.durationSeconds ];
      case SampleRate.hz104:
        cmd = [commandCode, 0x04, 0x01, 0x06, 0x06, params.durationSeconds ];
    }
    print( 'RTSOS Command: ' + cmd.toString() );
    await bleService.sendCommand(
      device: params.sensor.device,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      cmd: cmd,
    );

    return Right(null);
  }

  Future<EitherErr<void>> sendStartStreamRSTOS(RacketSensor sensor) async {
    final serviceUuid = Guid('93a72a53-fa2a-11e7-8c3f-9a214cf093ae');
    final characteristicUuid = Guid("93a72a53-fa2a-11e7-8c3f-9a214cf093ae");
    final services = await sensor.device.discoverServices();
    final service = services.firstWhere((s) => s.uuid == serviceUuid);
    final characteristic = service.characteristics.firstWhere((c) => c.uuid == characteristicUuid);

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
      cmd: [0x24],
    );

    return Right(null);
  }

  Future<EitherErr<List<Blob>>> readAllBlobs(RacketSensor sensor) async {
    try {
      final blobs = await storageServiceController.fetchBlobs(sensor.device, fetchData: true);

      if (blobs != null) {
        for (final blob in blobs) {
          final exists = await blobSqliteDB.existsBlob(blob.createdAt!);
          if (!exists) {
            final parsed = await parseBlob(blob);
            parsed.fold(
              (_) => null,
              (parsedData) => blobSqliteDB.insertParsedBlob(blob.createdAt!, parsedData),
            );
          }
        }
      }

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

      final int timestampSeconds = now.millisecondsSinceEpoch ~/ 1000;
      final int ms = now.microsecond ~/ 1000;

      final List<int> timestampValue = []
        ..addAll(_toBytes(timestampSeconds, 4))
        ..addAll(_toBytes(ms, 2));

      final int year = now.year;
      final int month = now.month;
      final int day = now.day;
      final int hour = now.hour;
      final int minute = now.minute;
      final int second = now.second;
      final int weekday = now.weekday;
      final int fraction256 = (now.microsecond * 256 ~/ 1000000);
      final int adjustReason = 0;

      final List<int> currentTimeValue = []
        ..addAll(_toBytes(year, 2))
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

      final timeCharacteristic = timeService.characteristics.firstWhere(
        (c) => c.uuid.toString().toLowerCase().contains('2a2b'),
        orElse: () => throw BluetoothErr(
          errMsg: 'Characteristic Current Time (2A2B) no encontrada.',
          statusCode: 404,
        ),
      );

      await timeCharacteristic.write(currentTimeValue, withoutResponse: false);

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

  return EitherCatch.catchAsync<void, BluetoothErr>(() async {
    final response = await bleService.sendCommand(
      device: sensor.device,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      cmd: eraseCommand,
    );

    if (response.length < 2 || response[1] != 0) {
      throw BluetoothErr(
        errMsg: 'Falló el borrado de memoria. Respuesta: $response',
        statusCode: 97,
      );
    }

    print('🧹 Memoria de blobs borrada correctamente');
    return;
  }, (e) {
    return BluetoothErr(
      errMsg: 'Error al borrar la memoria: ${e.toString()}',
      statusCode: 99,
    );
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

      final int seconds = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);
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
 