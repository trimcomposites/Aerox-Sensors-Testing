import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/connect_to_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';

void main() {
  late ConnectToRacketSensorUsecase connectToRacketSensorUsecase;
  late BluetoothRepository bluetoothRepository;

  setUp(() {
    bluetoothRepository = MockBluetoothRepository();
    connectToRacketSensorUsecase = ConnectToRacketSensorUsecase(bluetoothRepository: bluetoothRepository);
  });

  final device = MockBluetoothDevice();
  final RacketSensorEntity sensorEntity = RacketSensorEntity(
    id: "1",
    name: "Sensor 1",
    sensors: [],
  );

  group('ConnectToRacketSensorUsecase', () {
    test('should return Right(void) when connection is successful', () async {
      when(() => bluetoothRepository.connectRacketSensorEntity(sensorEntity))
          .thenAnswer((_) async => Right(unit));

      final result = await connectToRacketSensorUsecase(sensorEntity);

      expect(result, equals(Right<Err, void>(unit)));
      verify(() => bluetoothRepository.connectRacketSensorEntity(sensorEntity)).called(1);
    });

    test('should return Left(BluetoothErr) when connection fails', () async {
      when(() => bluetoothRepository.connectRacketSensorEntity(sensorEntity))
          .thenAnswer((_) async => Left(BluetoothErr(errMsg: "Connection failed", statusCode: 1)));

      final result = await connectToRacketSensorUsecase(sensorEntity);

      expect(result, isA<Left<Err, void>>());
      verify(() => bluetoothRepository.connectRacketSensorEntity(sensorEntity)).called(1);
    });
  });
}
