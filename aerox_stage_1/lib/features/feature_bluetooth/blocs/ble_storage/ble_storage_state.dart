part of 'ble_storage_bloc.dart';

class BleStorageState {
  const BleStorageState({
  required this.uiState,
      this.selectedRacketEntity,
      this.blobs = const [],
      this.filteredBlobs = const []
      //this.packets  = const []
    });

  final UIState uiState;
  final RacketSensorEntity? selectedRacketEntity;
  final List<Blob> blobs;
  final List<Blob> filteredBlobs;
  //final List<BlobPacket> packets;

  BleStorageState copyWith({
    UIState? uiState,
    RacketSensorEntity? selectedRacketEntity,
    List<Blob>? blobs,
    List<Blob>? filteredBlobs,
  }) {
    return BleStorageState(
      uiState: uiState ?? this.uiState,
      selectedRacketEntity: selectedRacketEntity,
      blobs: blobs ?? this.blobs,
      filteredBlobs: filteredBlobs ?? this.filteredBlobs

    );
  }

  @override
  List<Object?> get props => [uiState, selectedRacketEntity, blobs, filteredBlobs];
}

