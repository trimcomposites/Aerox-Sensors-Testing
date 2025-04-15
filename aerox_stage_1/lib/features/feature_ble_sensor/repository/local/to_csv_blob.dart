import 'dart:io';

import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/blob_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class ToCsvBlob {



Future<EitherErr<File>> exportParsedBlobToCsv(
  List<Map<String, dynamic>> parsedData, {
  String fileName = 'parsed_blob',
}) {
  return EitherCatch.catchAsync<File, BlobErr>(() async {
    final headers = parsedData.isNotEmpty ? parsedData.first.keys.toList() : [];
    final rows = parsedData.map((e) => headers.map((h) => e[h]).toList()).toList();
    final csvData = const ListToCsvConverter().convert([headers, ...rows]);

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName.csv';
    final file = File(filePath);
    await file.writeAsString(csvData);

    print('✅ CSV exportado correctamente a $filePath');
    return file;
  }, (error) {
    return BlobErr(
      errMsg: 'Error al exportar CSV: ${error.toString()}',
      statusCode: 500,
    );
  });
}
}