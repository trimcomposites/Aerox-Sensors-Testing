part of 'blob_database_bloc.dart';

class BlobDatabaseState extends Equatable{

    final List<ParsedBlob> blobs;
    final List<ParsedBlob> filteredBlobs;
    final UIState uiState;

  BlobDatabaseState({
    this.blobs = const [], 
    this.filteredBlobs = const [], 
    required this.uiState
    });

  copyWith({
    List<ParsedBlob>? blobs,
    List<ParsedBlob>? filteredBlobs,
    UIState? uiState
  }) => BlobDatabaseState(
            blobs: blobs ?? this.blobs, 
            filteredBlobs: filteredBlobs ?? this.filteredBlobs, 
            uiState: uiState ?? this.uiState
            );
  
  @override

  List<Object?> get props => [ blobs, filteredBlobs, uiState ];

}

