import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/get_selected_bluetooth_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import '../../../mock_types.dart';

void main() {
  late GetSelectedBluetoothRacketUsecase getSelectedBluetoothRacketUsecase;
  late BluetoothRepository bluetoothRepository;

  setUp(() {
    bluetoothRepository = MockBluetoothRepository();
    getSelectedBluetoothRacketUsecase = GetSelectedBluetoothRacketUsecase(bluetoothRepository: bluetoothRepository);
  });

  final RacketSensorEntity sensorEntity = RacketSensorEntity(
    id: "1",
    name: "Sensor 1",
    sensors: [],
  );

  group('GetSelectedBluetoothRacketUsecase', () {
    test('should return Right(RacketSensorEntity) when a selected racket exists', () async {
      when(() => bluetoothRepository.getSelectedRacketEntity())
          .thenAnswer((_) async => Right(sensorEntity));

      final result = await getSelectedBluetoothRacketUsecase();

      expect(result, equals(Right<Err, RacketSensorEntity?>(sensorEntity)));
      verify(() => bluetoothRepository.getSelectedRacketEntity()).called(1);
    });

    test('should return Right(null) when no selected racket exists', () async {
      when(() => bluetoothRepository.getSelectedRacketEntity())
          .thenAnswer((_) async => Right(null));

      final result = await getSelectedBluetoothRacketUsecase();

      expect(result, equals(Right<Err, RacketSensorEntity?>(null)));
      verify(() => bluetoothRepository.getSelectedRacketEntity()).called(1);
    });

    test('should return Left(BluetoothErr) when fetching selected racket fails', () async {
      when(() => bluetoothRepository.getSelectedRacketEntity())
          .thenAnswer((_) async => Left(BluetoothErr(errMsg: "Failed to fetch selected racket", statusCode: 1)));

      final result = await getSelectedBluetoothRacketUsecase();

      expect(result, isA<Left<Err, RacketSensorEntity?>>());
      verify(() => bluetoothRepository.getSelectedRacketEntity()).called(1);
    });
  });
}
