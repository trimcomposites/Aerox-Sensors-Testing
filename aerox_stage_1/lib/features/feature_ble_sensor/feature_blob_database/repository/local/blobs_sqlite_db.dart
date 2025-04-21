import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

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
        data TEXT NOT NULL,
        path TEXT DEFAULT ''
      )
    ''');
  }

  Future<void> insertParsedBlob(DateTime createdAt, List<Map<String, dynamic>> parsedData, {String path = ''}) async {
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
        'path': path,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatePathForBlob(DateTime createdAt, String path) async {
    final db = await database;
    await db.update(
      'parsed_blobs',
      {'path': path},
      where: 'createdAt = ?',
      whereArgs: [createdAt.toIso8601String()],
    );
    print( 'path updated' + path );
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

  Future<String?> getPathForBlob(DateTime createdAt) async {
    final db = await database;
    final result = await db.query(
      'parsed_blobs',
      columns: ['path'],
      where: 'createdAt = ?',
      whereArgs: [createdAt.toIso8601String()],
    );
    if (result.isNotEmpty) {
      return result.first['path'] as String;
    }
    return null;
  }
Future<List<Map<String, dynamic>>> getAllParsedBlobs() async {
  final db = await database;
  return await db.query('parsed_blobs');
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
  
Future<void> deleteDatabaseFile() async {
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, 'blobs_database.db');
  final dbFile = File(path);
  if (await dbFile.exists()) {
    await dbFile.delete();
    print("🧹 Base de datos eliminada");
  }
}

  Future<List<DateTime>> getAllBlobTimestamps() async {
    final db = await database;
    final result = await db.query('parsed_blobs', columns: ['createdAt']);
    return result.map((e) => DateTime.parse(e['createdAt'] as String)).toList();
  }
}
