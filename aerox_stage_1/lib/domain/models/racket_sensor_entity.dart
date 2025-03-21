import 'package:aerox_stage_1/domain/models/racket_sensor.dart';

class RacketSensorEntity {
  final String name;
  final String id;
  final List<RacketSensor> sensors;

  RacketSensorEntity({required this.name, required this.id, required this.sensors});
}