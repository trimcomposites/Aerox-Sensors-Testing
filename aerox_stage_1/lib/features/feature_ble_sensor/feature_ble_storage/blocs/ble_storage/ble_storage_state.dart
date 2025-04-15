part of 'ble_storage_bloc.dart';

class BleStorageState {
  const BleStorageState({
  required this.uiState,
      this.selectedRacketEntity,
      this.blobs = const [],
      this.filteredBlobs = const [],
      this.parsedBlobs = const []
    });

  final UIState uiState;
  final RacketSensorEntity? selectedRacketEntity;
  final List<Blob> blobs;
  final List<Blob> filteredBlobs;
  final List<List<Map<String, dynamic>>> parsedBlobs;
  //final List<BlobPacket> packets;

  BleStorageState copyWith({
    UIState? uiState,
    RacketSensorEntity? selectedRacketEntity,
    List<Blob>? blobs,
    List<Blob>? filteredBlobs,
    List<List<Map<String, dynamic>>>? parsedBlobs
  }) {
    return BleStorageState(
      uiState: uiState ?? this.uiState,
      selectedRacketEntity: selectedRacketEntity,
      blobs: blobs ?? this.blobs,
      filteredBlobs: filteredBlobs ?? this.filteredBlobs,
      parsedBlobs: parsedBlobs ?? this.parsedBlobs
    );
  }

  @override
  List<Object?> get props => [uiState, selectedRacketEntity, blobs, filteredBlobs, parsedBlobs];
}

