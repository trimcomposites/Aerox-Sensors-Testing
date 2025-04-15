import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:open_filex/open_filex.dart';

class BlobSQLiteDB {
  static final BlobSQLiteDB _instance = BlobSQLiteDB._internal();
  static Database? _database;

  factory BlobSQLiteDB() => _instance;

  BlobSQLiteDB._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'blobs_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE parsed_blobs (
        createdAt TEXT PRIMARY KEY,
        data TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertParsedBlob(DateTime createdAt, List<Map<String, dynamic>> parsedData) async {
    final db = await database;

    final cleanedData = parsedData.map((row) {
      return row.map((key, value) {
        if (value is DateTime) {
          return MapEntry(key, value.toIso8601String());
        }
        return MapEntry(key, value);
      });
    }).toList();

    final dataJson = jsonEncode(cleanedData);

    await db.insert(
      'parsed_blobs',
      {
        'createdAt': createdAt.toIso8601String(),
        'data': dataJson,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
}


  Future<List<Map<String, dynamic>>?> getParsedBlob(DateTime createdAt) async {
    final db = await database;
    final result = await db.query(
      'parsed_blobs',
      where: 'createdAt = ?',
      whereArgs: [createdAt.toIso8601String()],
    );

    if (result.isNotEmpty) {
      return List<Map<String, dynamic>>.from(jsonDecode(result.first['data'] as String));
    }
    return null;
  }

  Future<List<List<Map<String, dynamic>>>> getAllParsedBlobs() async {
    final db = await database;
    final result = await db.query('parsed_blobs');

    return result.map((row) {
      final dataJson = row['data'] as String;
      final List<dynamic> dataList = jsonDecode(dataJson);
      return List<Map<String, dynamic>>.from(dataList);
    }).toList();
  }

  Future<void> exportParsedBlobToCsv(DateTime createdAt, {String? customFileName}) async {
    try {
      final parsedData = await getParsedBlob(createdAt);
      if (parsedData == null || parsedData.isEmpty) {
        print('⚠️ No parsed data found for $createdAt');
        return;
      }

      final headers = parsedData.first.keys.toList();
      final rows = parsedData.map((e) => headers.map((h) => e[h]).toList()).toList();
      final csvData = const ListToCsvConverter().convert([headers, ...rows]);

      final dir = await getApplicationDocumentsDirectory();
      final fileName = customFileName ?? 'blob_${createdAt.toIso8601String()}';
      final filePath = '${dir.path}/$fileName.csv';
      final file = File(filePath);
      await file.writeAsString(csvData);

      final result = await OpenFilex.open(filePath);
      print('CSV export result: ${result.message}');
    } catch (e) {
      print('❌ Error exporting CSV: $e');
    }
  }

  Future<bool> existsBlob(DateTime createdAt) async {
    final db = await database;
    final result = await db.query(
      'parsed_blobs',
      where: 'createdAt = ?',
      whereArgs: [createdAt.toIso8601String()],
    );
    return result.isNotEmpty;
  }

  Future<void> clearParsedBlobs() async {
    final db = await database;
    await db.delete('parsed_blobs');
  }

  Future<List<DateTime>> getAllBlobTimestamps() async {
    final db = await database;
    final result = await db.query('parsed_blobs', columns: ['createdAt']);
    return result.map((e) => DateTime.parse(e['createdAt'] as String)).toList();
  }
}
