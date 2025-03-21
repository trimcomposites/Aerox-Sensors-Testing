part of 'sensors_bloc.dart';


class SensorsState extends Equatable {
  const SensorsState({ this.sensors = const [], required this.uiState });

  final List<RacketSensorEntity> sensors;
  final UIState uiState;
  SensorsState copyWith({
    List<RacketSensorEntity>? sensors,
    UIState? uiState
    }) {
    return SensorsState(
      sensors: sensors ?? this.sensors,
      uiState: uiState ?? this.uiState
    );
  }
  @override
  List<Object> get props => [ sensors, uiState ];
}