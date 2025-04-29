import 'package:equatable/equatable.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';

class RacketSensorEntity extends Equatable {
  final String name;
  final String id;
  final List<RacketSensor> sensors;

  const RacketSensorEntity({
    required this.name,
    required this.id,
    required this.sensors,
  });

  RacketSensorEntity copyWith({
    String? name,
    String? id,
    List<RacketSensor>? sensors,
  }) {
    return RacketSensorEntity(
      name: name ?? this.name,
      id: id ?? this.id,
      sensors: sensors ?? this.sensors,
    );
  }

  @override
  List<Object?> get props => [name, id, sensors];
}
