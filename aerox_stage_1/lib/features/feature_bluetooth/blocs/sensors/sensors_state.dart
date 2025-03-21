part of 'sensors_bloc.dart';


class SensorsState extends Equatable {
  const SensorsState({ this.sensors = const [] });

  final List<RacketSensorEntity> sensors;
  SensorsState copyWith({List<RacketSensorEntity>? sensors}) {
    return SensorsState(
      sensors: sensors ?? this.sensors,
    );
  }
  @override
  List<Object> get props => [ sensors ];
}