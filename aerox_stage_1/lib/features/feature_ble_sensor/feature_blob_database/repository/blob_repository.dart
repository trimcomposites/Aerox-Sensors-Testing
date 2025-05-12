import 'dart:convert';
import 'dart:io';

import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/blob_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/error_log.dart';
import 'package:aerox_stage_1/domain/models/parsed_blob.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/repository/local/blobs_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/to_csv_blob.dart';
import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';

class BlobRepository {
  final BlobSQLiteDB blobSQLiteDB;
  final ToCsvBlob toCsvBlob;

  BlobRepository({
    required this.blobSQLiteDB,
    required this.toCsvBlob
  });

Future<EitherErr<List<ParsedBlob>>> getAllBlobsFromDB() {
  return EitherCatch.catchAsync<List<ParsedBlob>, BlobErr>(() async {
    final rawBlobs = await blobSQLiteDB.getParsedBlobsIndividually();
    List<ParsedBlob> parsedBlobs = [];

    for (var row in rawBlobs) {
      final createdAt = DateTime.parse(row['createdAt'] as String);
      final path = row['path'] as String;
      final position = row['position'] as String;
      final List<dynamic> contentList = jsonDecode(row['data'] as String);
      final content = List<Map<String, dynamic>>.from(contentList);

      parsedBlobs.add(ParsedBlob(
        content: content,
        createdAt: createdAt,
        path: path,
        position: position,
        fileName: 'BLOB $position $createdAt'
      ));
    }

    return parsedBlobs;
  }, (exception) {
    return BlobErr(
      errMsg: exception.toString(),
      statusCode: 1,
    );
  });
}
Future<EitherErr<void>> insertErrorLog({
  required ErrorLog errorlog
}) {
  return EitherCatch.catchAsync<void, BlobErr>(() async {
    await blobSQLiteDB.logError(
      sensorPosition: errorlog.content,
      message: 'message',
      timestamp: errorlog.date,
    );
  }, (e) {
    return BlobErr(
      errMsg: 'Error al insertar log: ${e.toString()}',
      statusCode: 1,
    );
  });
}

Future<EitherErr<List<ErrorLog>>> getErrorLogsFromDB() {
  return EitherCatch.catchAsync<List<ErrorLog>, BlobErr>(() async {
    final rawLogs = await blobSQLiteDB.getAllErrorLogs();
    List<ErrorLog> errorLogs = [];

    for (var row in rawLogs) {
      final id = row['id'] as String;
      final date = DateTime.parse(row['date'] as String);
      final content = row['content'] as String;

      errorLogs.add(ErrorLog(
        id: id,
        date: date,
        content: content,
      ));
    }

    return errorLogs;
  }, (exception) {
    return BlobErr(
      errMsg: exception.toString(),
      statusCode: 1,
    );
  });
}


Future<EitherErr<List<File>>> exportToSCVBlobs(List<ParsedBlob> blobs) {
  return EitherCatch.catchAsync<List<File>, BlobErr>(() async {
    final List<File> resultList = [];

    for (var i = 0; i < blobs.length; i++) {
      print( 'exportar ${blobs.length} blobs ' );
      final result = await toCsvBlob
          .exportParsedBlobToCsv(blobs[i], fileName: 'parsed_blob_$i')
          .flatMap<File>((file) async {
            resultList.add(file);
            final dir = await getApplicationDocumentsDirectory();
            final fileName = '${'BLOB ${blobs[i].position} ${blobs[i].createdAt}'}.csv';
            final path = '${dir.path}/${fileName}';

            await file.copy(path);

            blobSQLiteDB.updatePathForBlob(blobs[i].createdAt, fileName);

            return Right(file);
          });
      
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