import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/comment_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_extension.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RacketBluetoothService {

  final BluetoothCustomService bluetoothService;

  RacketBluetoothService({required this.bluetoothService});

  Future<EitherErr<Stream<List<RacketSensor>>>> scanAllRacketDevices() {
    return bluetoothService.startScan();
  }
  Future<EitherErr<void>> stopScanRacketDevices() {
    return bluetoothService.stopScan();
  }

}