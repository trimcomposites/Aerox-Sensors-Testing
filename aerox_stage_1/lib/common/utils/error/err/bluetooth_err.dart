import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';


class BluetoothErr extends Err{
  final RacketSensor? sensor;
  BluetoothErr( { 
    this.sensor,
    required super.errMsg, 
    required super.statusCode, 
  });

}