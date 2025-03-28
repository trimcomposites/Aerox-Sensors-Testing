import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/racket_bluetooth_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';

void main() {
  late BluetoothRepository bluetoothRepository;
  late RacketBluetoothService bluetoothService;

  setUp(() {
    bluetoothService = MockRacketBluetoothService();
    bluetoothRepository = BluetoothRepository(bluetoothService: bluetoothService);
  });

  final RacketSensorEntity sensorEntity = RacketSensorEntity(id: "1", name: "Sensor 1", sensors: []);
  final List<RacketSensorEntity> entities = [sensorEntity];
  final stream = Stream.value(entities);

  group('BluetoothRepository', () {
    test('startSensorsScan returns stream of RacketSensorEntity', () async {
      when(() => bluetoothService.scanAllRacketDevices())
          .thenAnswer((_) async => Right(stream));

      final result = await bluetoothRepository.startSensorsScan();

      expect(result, isA<Right<Err, Stream<List<RacketSensorEntity>>>>());
      verify(() => bluetoothService.scanAllRacketDevices()).called(1);
    });

    test('stopSensorsScan returns void', () async {
      when(() => bluetoothService.stopScanRacketDevices())
          .thenAnswer((_) async => Right(null));

      final result = await bluetoothRepository.stopSensorsScan();

      expect(result, equals(Right<Err, void>(null)));
      verify(() => bluetoothService.stopScanRacketDevices()).called(1);
    });

    test('connectRacketSensorEntity returns void', () async {
      when(() => bluetoothService.connectRacketSensorEntity(sensorEntity))
          .thenAnswer((_) async => Right(null));

      final result = await bluetoothRepository.connectRacketSensorEntity(sensorEntity);

      expect(result, equals(Right<Err, void>(null)));
      verify(() => bluetoothService.connectRacketSensorEntity(sensorEntity)).called(1);
    });

    test('disconnectRacketSensorEntity returns void', () async {
      when(() => bluetoothService.disconnectRacketSensorEntity(sensorEntity))
          .thenAnswer((_) async => Right(null));

      final result = await bluetoothRepository.disconnectRacketSensorEntity(sensorEntity);

      expect(result, equals(Right<Err, void>(null)));
      verify(() => bluetoothService.disconnectRacketSensorEntity(sensorEntity)).called(1);
    });

    test('reScan returns void', () async {
      when(() => bluetoothService.reScan())
          .thenAnswer((_) async => Right(null));

      final result = await bluetoothRepository.reScan();

      expect(result, equals(Right<Err, void>(null)));
      verify(() => bluetoothService.reScan()).called(1);
    });

    test('getSelectedRacketEntity returns a RacketSensorEntity', () async {
      when(() => bluetoothService.getConnectedRacketEntity())
          .thenAnswer((_) async => Right(sensorEntity));

      final result = await bluetoothRepository.getSelectedRacketEntity();

      expect(result, equals(Right<Err, RacketSensorEntity?>(sensorEntity)));
      verify(() => bluetoothService.getConnectedRacketEntity()).called(1);
    });
  });
}
