import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_service.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/racket_bluetooth_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';

void main() {
  late RacketBluetoothService racketBluetoothService;
  late BluetoothCustomService bluetoothService;

  setUp(() {
    bluetoothService = MockBluetoothCustomService();
    racketBluetoothService = RacketBluetoothService(bluetoothService: bluetoothService);
  });

  final device = MockBluetoothDevice();
  final RacketSensor sensor1 = RacketSensor(id: "1", name: "SmartInsole", device: device, connectionState: BluetoothConnectionState.connected);
  final RacketSensor sensor2 = RacketSensor(id: "2", name: "SmartInsole", device: device, connectionState: BluetoothConnectionState.connected);
  final List<RacketSensor> sensorList = [sensor1, sensor2];

  group('scanAllRacketDevices', () {
    test('returns stream of RacketSensorEntity', () async {
      final stream = Stream.value(sensorList);
      when(() => bluetoothService.startScan(filterName: any(named: 'filterName')))
          .thenAnswer((_) async => Right(Stream.value(sensorList)));

      final result = await racketBluetoothService.scanAllRacketDevices();

      expect(result.isRight(), true);
      expect(await result.getOrElse(() => Stream.empty()).first, isA<List<RacketSensorEntity>>());
    });

    test('returns Left when scan fails', () async {
      when(() => bluetoothService.startScan(filterName: any(named: 'filterName')))
          .thenAnswer((_) async => Left(BluetoothErr(errMsg: "Scan failed", statusCode: 1)));

      final result = await racketBluetoothService.scanAllRacketDevices();

      expect(result, isA<Left<Err, Stream<List<RacketSensorEntity>>>>());
    });
  });

  group('stopScanRacketDevices', () {
    test('returns Right on success', () async {
      when(() => bluetoothService.stopScan()).thenAnswer((_) async => Right(null));

      final result = await racketBluetoothService.stopScanRacketDevices();

      expect(result, equals(Right<Err, void>(null)));
    });

    test('returns Left on failure', () async {
      when(() => bluetoothService.stopScan())
          .thenAnswer((_) async => Left(BluetoothErr(errMsg: 'fail', statusCode: 1)));

      final result = await racketBluetoothService.stopScanRacketDevices();

      expect(result.isLeft(), true);
    });
  });

  group('reScan', () {
    test('returns Right on success', () async {
      when(() => bluetoothService.reScan()).thenAnswer((_) async => Right(null));

      final result = await racketBluetoothService.reScan();

      expect(result, equals(Right<Err, void>(null)));
    });

    test('returns Left on failure', () async {
      when(() => bluetoothService.reScan()).thenAnswer((_) async => Left(BluetoothErr(errMsg: 'rescan failed', statusCode: 1)));

      final result = await racketBluetoothService.reScan();

      expect(result.isLeft(), true);
    });
  });

  group('connectRacketSensorEntity', () {
    final entity = RacketSensorEntity(id: '1', name: 'SmartInsole', sensors: sensorList);

    test('returns Right when all sensors connect successfully', () async {
    for (var sensor in sensorList){
      when(() => bluetoothService.connectToDevice(sensor))
          .thenAnswer((_) async => Right(null));
    }
      final result = await racketBluetoothService.connectRacketSensorEntity(entity);

      expect(result, equals(Right<Err, void>(null)));
    });

    test('returns Left if any sensor connection fails', () async {
      when(() => bluetoothService.connectToDevice(sensor1))
          .thenAnswer((_) async => Left(BluetoothErr(errMsg: 'connection failed', statusCode: 1)));

      final result = await racketBluetoothService.connectRacketSensorEntity(entity);

      expect(result.isLeft(), true);
    });
  });

  group('disconnectRacketSensorEntity', () {
    final entity = RacketSensorEntity(id: '1', name: 'SmartInsole', sensors: sensorList);

  test('returns Right when all sensors connect successfully', () async {
    for (var sensor in sensorList) {
      when(() => bluetoothService.connectToDevice(sensor))
          .thenAnswer((_) async => Right(null));
    }

    final result = await racketBluetoothService.connectRacketSensorEntity(entity);

    expect(result, equals(Right<Err, void>(null)));
  });


  test('returns Left if any sensor disconnection fails', () async {
    when(() => bluetoothService.disconnectFromDevice(sensor1))
        .thenAnswer((_) async => Right(null));
    when(() => bluetoothService.disconnectFromDevice(sensor2))
        .thenAnswer((_) async => Left(BluetoothErr(errMsg: 'disconnection failed', statusCode: 1)));

    final result = await racketBluetoothService.disconnectRacketSensorEntity(entity);

    expect(result.isLeft(), true);
  });

  });

  group('getConnectedRacketEntity', () {
    test('returns Right with entity when sensors are connected', () async {
      when(() => bluetoothService.getConnectedSensors())
          .thenAnswer((_) async => Right(sensorList));

      final result = await racketBluetoothService.getConnectedRacketEntity();

      expect(result, isA<Right<Err, RacketSensorEntity?>>());
      expect(result.getOrElse(() => null)?.sensors.length, 2);
    });

    test('returns Right(null) when no sensors connected', () async {
      when(() => bluetoothService.getConnectedSensors())
          .thenAnswer((_) async => Right([]));

      final result = await racketBluetoothService.getConnectedRacketEntity();

      expect(result.getOrElse(() => RacketSensorEntity(id: '', name: '', sensors: [])), isNull);
    });

    test('returns Left on failure', () async {
      when(() => bluetoothService.getConnectedSensors())
          .thenAnswer((_) async => Left(BluetoothErr(errMsg: 'error', statusCode: 1)));

      final result = await racketBluetoothService.getConnectedRacketEntity();

      expect(result.isLeft(), true);
    });
  });
}
