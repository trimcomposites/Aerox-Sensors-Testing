import 'package:aerox_stage_1/common/services/read_blobs_task_handler.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class ReadStorageDataForegroundUsecase extends AsyncUseCaseWithParams<void, List<RacketSensor>> {
  final BleRepository bleRepository;

  ReadStorageDataForegroundUsecase({required this.bleRepository});

  @override
  Future<EitherErr<void>> call(List<RacketSensor> sensors) async {
    try {
      final sensorIds = sensors.map((s) => s.device.remoteId.str).toList();
      await FlutterForegroundTask.saveData(key: 'sensorIds', value: sensorIds);

      await FlutterForegroundTask.startService(
        notificationTitle: 'Leyendo blobs en segundo plano',
        notificationText: 'Extrayendo datos de sensores conectados...',
        callback: () {
          FlutterForegroundTask.setTaskHandler(
            ReadBlobTaskHandler(bleRepository: bleRepository),
          );
        },
      );

      return const Right(null);
    } catch (e) {
      return Left(BluetoothErr(errMsg: '', statusCode: 1));
    }
  }
}