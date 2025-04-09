import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class ToCsvBlob {



Future<void> exportParsedBlobToCsv(List<Map<String, dynamic>> parsedData, {String fileName = 'parsed_blob'}) async {
  try {

    final headers = parsedData.isNotEmpty ? parsedData.first.keys.toList() : [];
    final rows = parsedData.map((e) => headers.map((h) => e[h]).toList()).toList();
    final csvData = const ListToCsvConverter().convert([headers, ...rows]);

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName.csv';
    final file = File(filePath);
    await file.writeAsString(csvData);

    final result = await OpenFilex.open(filePath);

    print('CSV export result: ${result.message}');
  } catch (e) {
    print('❌ Error exporting CSV: $e');
  }
}

}