import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/disconnect_from_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import '../../../mock_types.dart';

void main() {
  late DisconnectFromRacketSensorUsecase disconnectFromRacketSensorUsecase;
  late BluetoothRepository bluetoothRepository;

  setUp(() {
    bluetoothRepository = MockBluetoothRepository();
    disconnectFromRacketSensorUsecase = DisconnectFromRacketSensorUsecase(bluetoothRepository: bluetoothRepository);
  });

  final RacketSensorEntity sensorEntity = RacketSensorEntity(
    id: "1",
    name: "Sensor 1",
    sensors: [],
  );

  group('DisconnectFromRacketSensorUsecase', () {
    test('should return Right(void) when disconnection is successful', () async {
      when(() => bluetoothRepository.disconnectRacketSensorEntity(sensorEntity))
          .thenAnswer((_) async => Right(unit));

      final result = await disconnectFromRacketSensorUsecase(sensorEntity);

      expect(result, equals(Right<Err, void>(unit)));
      verify(() => bluetoothRepository.disconnectRacketSensorEntity(sensorEntity)).called(1);
    });

    test('should return Left(BluetoothErr) when disconnection fails', () async {
      when(() => bluetoothRepository.disconnectRacketSensorEntity(sensorEntity))
          .thenAnswer((_) async => Left(BluetoothErr(errMsg: "Disconnection failed", statusCode: 1)));

      final result = await disconnectFromRacketSensorUsecase(sensorEntity);

      expect(result, isA<Left<Err, void>>());
      verify(() => bluetoothRepository.disconnectRacketSensorEntity(sensorEntity)).called(1);
    });
  });
}
