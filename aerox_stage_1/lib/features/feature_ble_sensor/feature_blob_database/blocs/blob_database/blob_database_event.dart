part of 'blob_database_bloc.dart';

class BlobDatabaseEvent {}

class OnReadBlobDatabase extends BlobDatabaseEvent {}
class OnGetErrorLogs extends BlobDatabaseEvent {}
class OnExportToCSVFilteredBlobs extends BlobDatabaseEvent {}
class OnUploadErrorLogs extends BlobDatabaseEvent {}

class OnUploadBlobsToStorage extends BlobDatabaseEvent {
  final List<ParsedBlob> blobs;

  OnUploadBlobsToStorage({required this.blobs});
}
class OnAddBlobToSelectedList extends BlobDatabaseEvent {
  final ParsedBlob blob;

  OnAddBlobToSelectedList({required this.blob});
}
class OnRemoveBlobFromSelectedList extends BlobDatabaseEvent {
  final ParsedBlob blob;

  OnRemoveBlobFromSelectedList({required this.blob});
}
class OnResetBlobSelectedList extends BlobDatabaseEvent {


  OnResetBlobSelectedList();
}
class OnEraseBlobDatabase extends BlobDatabaseEvent {


  OnEraseBlobDatabase();
}
class OnAddAllBlobsToSelectedList extends BlobDatabaseEvent {


  OnAddAllBlobsToSelectedList();
}
class OnFilterDatabaseBlobsByExactDate extends BlobDatabaseEvent {
  final DateTime exactDate;

  OnFilterDatabaseBlobsByExactDate(this.exactDate);
}
class OnFilterDatabaseBlobsUntilDate extends BlobDatabaseEvent {
  final DateTime untilDate;

  OnFilterDatabaseBlobsUntilDate(this.untilDate);
}
