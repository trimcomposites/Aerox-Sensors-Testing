part of 'sensors_bloc.dart';


class SensorsState extends Equatable {
  const SensorsState({ this.sensors = const [], required this.uiState, this.selectedRacketEntity });

  final List<RacketSensorEntity> sensors;
  final UIState uiState;
  final RacketSensorEntity? selectedRacketEntity;
  SensorsState copyWith({
    List<RacketSensorEntity>? sensors,
    UIState? uiState,
    RacketSensorEntity? selectedRacketEntity
    }) {
    return SensorsState(
      sensors: sensors ?? this.sensors,
      uiState: uiState ?? this.uiState,
      selectedRacketEntity: selectedRacketEntity
    );
  }
  @override
  List<Object?> get props => [ sensors, uiState, selectedRacketEntity ];
}