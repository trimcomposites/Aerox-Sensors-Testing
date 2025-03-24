part of 'selected_entity_page_bloc.dart';

class SelectedEntityPageState extends Equatable {
  const SelectedEntityPageState({  required this.uiState, this.selectedRacketEntity });

  final UIState uiState;
  final RacketSensorEntity? selectedRacketEntity;
  SelectedEntityPageState copyWith({
    UIState? uiState,
    RacketSensorEntity? selectedRacketEntity
    }) {
    return SelectedEntityPageState(
      uiState: uiState ?? this.uiState,
      selectedRacketEntity: selectedRacketEntity 
    );
  }
  @override
  List<Object?> get props => [ uiState, selectedRacketEntity ];
}