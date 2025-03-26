import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/stop_scan_bluetooth_sensors_usecase.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import '../../../mock_types.dart';

void main() {
  late StoptScanBluetoothSensorsUsecase stopScanUseCase;
  late BluetoothRepository bluetoothRepository;

  setUp(() {
    bluetoothRepository = MockBluetoothRepository();
    stopScanUseCase = StoptScanBluetoothSensorsUsecase(bluetoothRepository: bluetoothRepository);
  });

  group('StoptScanBluetoothSensorsUsecase', () {
    test('should return Right(void) when stop scan is successful', () async {
      when(() => bluetoothRepository.stopSensorsScan())
          .thenAnswer((_) async => Right(null));

      final result = await stopScanUseCase();

      expect(result, equals(Right<Err, void>(null)));
      verify(() => bluetoothRepository.stopSensorsScan()).called(1);
    });

    test('should return Left(BluetoothErr) when stop scan fails', () async {
      when(() => bluetoothRepository.stopSensorsScan())
          .thenAnswer((_) async => Left(BluetoothErr(errMsg: "Stop scan failed", statusCode: 1)));

      final result = await stopScanUseCase();

      expect(result, isA<Left<Err, void>>());
      verify(() => bluetoothRepository.stopSensorsScan()).called(1);
    });
  });
}
