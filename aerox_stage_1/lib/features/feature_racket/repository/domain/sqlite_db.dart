import 'dart:async';
import 'dart:io';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDB {
  static final SQLiteDB _instance = SQLiteDB._internal();
  static Database? _database;

  factory SQLiteDB() {
    return _instance;
  }

  SQLiteDB._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rackets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        img TEXT,
        length NUMERIC,
        weight NUMERIC,
        pattern TEXT,
        balance NUMERIC
      )
    ''');

  }
   Future<int> insertRacket(Racket racket) async {
    final db = await database;
    return await db.insert('rackets', racket.toMap());
  }

  Future<List<Racket>> getAllRackets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('rackets');

    return List.generate(maps.length, (i) {
      return Racket.fromMap(maps[i]);
    });
  }

  Future<int> updateRacket(Racket racket) async {
    final db = await database;
    return await db.update(
      'rackets',
      racket.toMap(),
      where: 'id = ?',
      whereArgs: [racket.id],
    );
  }

  Future<int> deleteRacket(int id) async {
    final db = await database;
    return await db.delete(
      'rackets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertRacketList(List<Racket> rackets) async {
    final db = await database;

    await db.transaction((txn) async {
      final batch = txn.batch(); 
      for (var racket in rackets) {
        batch.insert('rackets', racket.toMap());
      }
      await batch.commit(noResult: true); 
    });
  }
}