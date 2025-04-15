import 'dart:io';

import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/blob_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/repository/local/blobs_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/to_csv_blob.dart';
import 'package:dartz/dartz.dart';

class BlobRepository {
  final BlobSQLiteDB blobSQLiteDB;
  final ToCsvBlob toCsvBlob;

  BlobRepository({
    required this.blobSQLiteDB,
    required this.toCsvBlob
  });
  
  Future<EitherErr<List<List<Map<String, dynamic>>>>> getAllBlobsFromDB() {
    return EitherCatch.catchAsync<List<List<Map<String, dynamic>>>, BlobErr>(() async {
      final localBlobs = await blobSQLiteDB.getAllParsedBlobs();
      return localBlobs;
    }, (exception) {
      return BlobErr(
        errMsg: exception.toString(),
        statusCode: 1,
      );
    });
  }
Future<EitherErr<List<File>>> exportToSCVBlobs(List<List<Map<String, dynamic>>> blobs) {
  return EitherCatch.catchAsync<List<File>, BlobErr>(() async {
    final List<File> resultList = [];

    for (var i = 0; i < blobs.length; i++) {
      final result = await toCsvBlob
          .exportParsedBlobToCsv(blobs[i], fileName: 'parsed_blob_$i')
          .flatMap<File>((file) async {
            resultList.add(file);
            return Right(file);
          });
      
      // Esto asegura que si `exportParsedBlobToCsv` da Left, el flatMap lanza y se detiene.
    }

    return resultList;
  }, (exception) {
    return BlobErr(
      errMsg: 'Error al exportar uno o más blobs: ${exception.toString()}',
      statusCode: 1,
    );
  });
}



}