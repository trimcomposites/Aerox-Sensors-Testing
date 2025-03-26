import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/start_scan_bluetooth_sensors_usecase.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import '../../../mock_types.dart';

void main() {
  late StartScanBluetoothSensorsUsecase startScanUsecase;
  late BluetoothRepository bluetoothRepository;

  setUp(() {
    bluetoothRepository = MockBluetoothRepository();
    startScanUsecase = StartScanBluetoothSensorsUsecase(bluetoothRepository: bluetoothRepository);
  });

  final List<RacketSensorEntity> sensorEntities = [
    RacketSensorEntity(id: "1", name: "Sensor 1", sensors: []),
    RacketSensorEntity(id: "2", name: "Sensor 2", sensors: []),
  ];

  final Stream<List<RacketSensorEntity>> sensorStream = Stream.value(sensorEntities);

  group('StartScanBluetoothSensorsUsecase', () {
    test('should return Right(Stream) when scan starts successfully', () async {
      when(() => bluetoothRepository.startSensorsScan())
          .thenAnswer((_) async => Right(sensorStream));

      final result = await startScanUsecase();

      expect(result, equals(Right<Err, Stream<List<RacketSensorEntity>>>(sensorStream)));
      verify(() => bluetoothRepository.startSensorsScan()).called(1);
    });

    test('should return Left(BluetoothErr) when scan fails', () async {
      when(() => bluetoothRepository.startSensorsScan())
          .thenAnswer((_) async => Left(BluetoothErr(errMsg: "Scan failed", statusCode: 1)));

      final result = await startScanUsecase();

      expect(result, isA<Left<Err, Stream<List<RacketSensorEntity>>>>());
      verify(() => bluetoothRepository.startSensorsScan()).called(1);
    });
  });
}
