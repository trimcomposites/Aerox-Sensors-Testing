import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BlobSQLiteDB {
  static final BlobSQLiteDB _instance = BlobSQLiteDB._internal();
  static Database? _database;

  factory BlobSQLiteDB() {
    return _instance;
  }

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
    final dataJson = jsonEncode(parsedData);

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
