import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/comment_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_extension.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_service.dart';
import 'package:dartz/dartz.dart';

class RacketBluetoothService {

  final BluetoothCustomService bluetoothService;

  RacketBluetoothService({required this.bluetoothService});

  Future<EitherErr<List<RacketSensor>>> scanAllRacketDevices() {
    return bluetoothService.scanDevices().flatMap((foundDevices) {
      
      if (foundDevices.isEmpty) {

        return Future.value(Right([]));
      } else {

        return Future.wait(
          foundDevices.map((device) => device.toRacketSensor()),
        ).then((sensors) => Right(sensors));
      }
    });
  }
}
