part of 'blob_database_bloc.dart';

class BlobDatabaseState extends Equatable {
  final UIState uiState;
  final List<ParsedBlob> blobs;
  final List<ParsedBlob> filteredBlobs;
  final List<ParsedBlob> selectedBlobs;

  const BlobDatabaseState({
    required this.uiState,
    this.blobs = const [],
    this.filteredBlobs = const [],
    this.selectedBlobs = const [],
  });

  BlobDatabaseState copyWith({
    UIState? uiState,
    List<ParsedBlob>? blobs,
    List<ParsedBlob>? filteredBlobs,
    List<ParsedBlob>? selectedBlobs,
  }) {
    return BlobDatabaseState(
      uiState: uiState ?? this.uiState,
      blobs: blobs ?? this.blobs,
      filteredBlobs: filteredBlobs ?? this.filteredBlobs,
      selectedBlobs: selectedBlobs ?? this.selectedBlobs,
    );
  }

  @override
  List<Object> get props => [uiState, blobs, selectedBlobs, filteredBlobs];
}
