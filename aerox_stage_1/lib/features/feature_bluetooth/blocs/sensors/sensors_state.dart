part of 'sensors_bloc.dart';


class SensorsState extends Equatable {
  const SensorsState({ this.sensors = const [] });

  final List<RacketSensor> sensors;
  SensorsState copyWith({List<RacketSensor>? sensors}) {
    return SensorsState(
      sensors: sensors ?? this.sensors,
    );
  }
  @override
  List<Object> get props => [ SensorsState ];
}