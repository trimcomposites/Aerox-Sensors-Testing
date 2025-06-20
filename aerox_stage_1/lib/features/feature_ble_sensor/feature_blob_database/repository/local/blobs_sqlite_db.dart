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
        id TEXT PRIMARY KEY,
        createdAt TEXT NOT NULL,
        data TEXT NOT NULL,
        path TEXT DEFAULT '',
        position TEXT DEFAULT ''
      )
    ''');
    await db.execute('''
      CREATE TABLE error_logs (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        content TEXT NOT NULL
      )
    ''');
  
  }

  String generateRandomId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }


Future<void> insertParsedBlob(
  DateTime createdAt,
  List<Map<String, dynamic>> parsedData, {
  String path = '',
  required String position,
}) async {
  try {
    final db = await database;

    // ⚠️ Verifica si ya existe
    final existing = await db.query(
      'parsed_blobs',
      where: 'createdAt = ? AND position = ?',
      whereArgs: [createdAt.toIso8601String(), position],
    );

    if (existing.isNotEmpty) {
      print('⛔️ Blob ya existe, no se insertará duplicado.');
      return;
    }

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
        'id': generateRandomId(),
        'createdAt': createdAt.toIso8601String(),
        'data': dataJson,
        'path': path,
        'position': position,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // Extra seguridad
    );
  } catch (e) {
    print('❌ Error insertando parsedBlob: $e');
  }
}


  Future<void> updatePathForBlob(DateTime createdAt, String path) async {
    final db = await database;

    final result = await db.query(
      'parsed_blobs',
      columns: ['path'],
      where: 'createdAt = ?',
      whereArgs: [createdAt.toIso8601String()],
    );

    final alreadySet = result.any((row) => row['path'] == path);
    if (alreadySet) return;

    await db.update(
      'parsed_blobs',
      {'path': path},
      where: 'createdAt = ?',
      whereArgs: [createdAt.toIso8601String()],
    );
    print('path updated: $path');
  }

  Future<void> updatePositionForBlob(DateTime createdAt, String position) async {
    final db = await database;
    await db.update(
      'parsed_blobs',
      {'position': position},
      where: 'createdAt = ?',
      whereArgs: [createdAt.toIso8601String()],
    );
    print('position updated: $position');
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

  Future<String?> getPositionForBlob(DateTime createdAt) async {
    final db = await database;
    final result = await db.query(
      'parsed_blobs',
      columns: ['position'],
      where: 'createdAt = ?',
      whereArgs: [createdAt.toIso8601String()],
    );
    if (result.isNotEmpty) {
      return result.first['position'] as String;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllParsedBlobs() async {
    final db = await database;
    final blobs=  await db.query('parsed_blobs');
    return blobs;
  }

  Future<List<Map<String, dynamic>>> getParsedBlobsIndividually() async {
    final db = await database;
    final timestamps = await db.query('parsed_blobs', columns: ['createdAt']);
    final parsedBlobs = <Map<String, dynamic>>[];

    for (final row in timestamps) {
      final createdAtStr = row['createdAt'] as String;
      final full = await db.query(
        'parsed_blobs',
        where: 'createdAt = ?',
        whereArgs: [createdAtStr],
      );

      if (full.isNotEmpty) {
        parsedBlobs.add(full.first);
      }

      await Future.delayed(Duration.zero);
    }

    return parsedBlobs;
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

    final tables = ['parsed_blobs', 'error_logs'];
    for (final table in tables) {
      await db.delete(table);
    }

    print('🧹 Todas las tablas limpiadas: ${tables.join(', ')}');
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

  Future<void> logError({
    required String sensorPosition,
    required String message,
    required DateTime timestamp,
  }) async {
    final db = await database;
    final todayStr = DateTime(timestamp.year, timestamp.month, timestamp.day).toIso8601String();

    final existing = await db.query(
      'error_logs',
      where: 'date = ?',
      whereArgs: [todayStr],
    );

    if (existing.isEmpty) {
      final newLog = '[$sensorPosition - ${timestamp.toIso8601String()}] $message\n';
      await db.insert(
        'error_logs',
        {
          'id': generateRandomId(),
          'date': todayStr,
          'content': newLog,
        },
      );
    } else {
      final currentLog = existing.first['content'] as String;
      final updatedLog = '$currentLog[${sensorPosition} - ${timestamp.toIso8601String()}] $message\n';
      await db.update(
        'error_logs',
        {'content': updatedLog},
        where: 'date = ?',
        whereArgs: [todayStr],
      );
    }
  }

  Future<String?> getErrorLogForDate(DateTime date) async {
    final db = await database;
    final dateStr = DateTime(date.year, date.month, date.day).toIso8601String();
    final result = await db.query(
      'error_logs',
      where: 'date = ?',
      whereArgs: [dateStr],
    );
    if (result.isNotEmpty) {
      return result.first['content'] as String;
    }
    return null;
  }
  Future<List<Map<String, dynamic>>> getAllErrorLogs() async {
    final db = await database;
    return await db.query('error_logs');
  }
} 
