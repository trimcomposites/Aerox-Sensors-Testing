part of 'ble_storage_bloc.dart';

class BleStorageState {
  const BleStorageState({
  required this.uiState,
      this.selectedRacketEntity,
      this.blobs = const [],
      this.filteredBlobs = const [],
      this.parsedBlobs = const [],
      this.blobsRead = 0,
      this.totalBlobs = 0,
    });

  final UIState uiState;
  final RacketSensorEntity? selectedRacketEntity;
  final List<Blob> blobs;
  final List<Blob> filteredBlobs;
  final List<List<Map<String, dynamic>>> parsedBlobs;
  final int blobsRead;
  final int totalBlobs;

  BleStorageState copyWith({
    UIState? uiState,
    RacketSensorEntity? selectedRacketEntity,
    List<Blob>? blobs,
    List<Blob>? filteredBlobs,
    List<List<Map<String, dynamic>>>? parsedBlobs,
    int? blobsRead,
    int? totalBlobs,
  }) {
    return BleStorageState(
      uiState: uiState ?? this.uiState,
      selectedRacketEntity: selectedRacketEntity,
      blobs: blobs ?? this.blobs,
      filteredBlobs: filteredBlobs ?? this.filteredBlobs,
      blobsRead: blobsRead ?? this.blobsRead,
      totalBlobs: totalBlobs ?? this.totalBlobs,
      parsedBlobs: parsedBlobs ?? this.parsedBlobs
    );
  }

  @override
  List<Object?> get props => [uiState, selectedRacketEntity, blobs, filteredBlobs, parsedBlobs, totalBlobs, blobsRead];
}

