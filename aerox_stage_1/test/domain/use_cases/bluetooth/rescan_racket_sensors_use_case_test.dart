import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/rescan_racket_sensors_use_case.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import '../../../mock_types.dart';

void main() {
  late ReScanRacketSensorsUseCase reScanUseCase;
  late BluetoothRepository bluetoothRepository;

  setUp(() {
    bluetoothRepository = MockBluetoothRepository();
    reScanUseCase = ReScanRacketSensorsUseCase(bluetoothRepository: bluetoothRepository);
  });

  group('ReScanRacketSensorsUseCase', () {
    test('should return Right(void) when rescan is successful', () async {
      when(() => bluetoothRepository.reScan())
          .thenAnswer((_) async => Right(null));

      final result = await reScanUseCase();

      expect(result, equals(Right<Err, void>(null)));
      verify(() => bluetoothRepository.reScan()).called(1);
    });

    test('should return Left(BluetoothErr) when rescan fails', () async {
      when(() => bluetoothRepository.reScan())
          .thenAnswer((_) async => Left(BluetoothErr(errMsg: "Rescan failed", statusCode: 1)));

      final result = await reScanUseCase();

      expect(result, isA<Left<Err, void>>());
      verify(() => bluetoothRepository.reScan()).called(1);
    });
  });
}
