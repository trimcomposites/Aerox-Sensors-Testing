part of 'selected_entity_page_bloc.dart';

class SelectedEntityPageState extends Equatable {
  const SelectedEntityPageState({
    required this.uiState,
    this.selectedRacketEntity,
    this.blobs = const [],
    //this.packets  = const []
  });

  final UIState uiState;
  final RacketSensorEntity? selectedRacketEntity;
  final List<Blob> blobs;
  //final List<BlobPacket> packets;

  SelectedEntityPageState copyWith({
    UIState? uiState,
    RacketSensorEntity? selectedRacketEntity,
    List<Blob>? blobs,
    //List<BlobPacket>? packets,
  }) {
    return SelectedEntityPageState(
      uiState: uiState ?? this.uiState,
      selectedRacketEntity: selectedRacketEntity,
      blobs: blobs ?? this.blobs,
      //packets: packets?? this.packets
    );
  }

  @override
  List<Object?> get props => [uiState, selectedRacketEntity, blobs,];
}
