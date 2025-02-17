import 'dart:async';
import 'dart:io';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/mock_racket_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aerox_stage_1/domain/models/racket_serializer.dart';

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
        golpeo TEXT NOT NULL,
        pala TEXT NOT NULL,
        nombrePala TEXT NOT NULL,
        color TEXT NOT NULL,
        weightNumber TEXT NOT NULL,
        weightName TEXT NOT NULL,
        weightType TEXT NOT NULL,
        balance TEXT NOT NULL,
        headType TEXT NOT NULL,
        swingWeight TEXT NOT NULL,
        potenciaType TEXT NOT NULL,
        acor TEXT NOT NULL,
        acorType TEXT NOT NULL,
        manejabilidad TEXT NOT NULL,
        manejabilidadType TEXT NOT NULL,
        imagen TEXT NOT NULL,
        isSelected INTEGER DEFAULT 0 
      )
    ''');
    //await insertRacketList(mockRackets, dbInstance: db); // Temp data
  }

  // Insertar una raqueta
  Future<int> insertRacket(Racket racket) async {
    final db = await database;
    return await db.insert('rackets', RacketSerializer.toJsonRacket(racket)); 
  }

  // Obtener todas las raquetas
  Future<List<Racket>> getAllRackets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('rackets');

    return List.generate(maps.length, (i) {
      return RacketSerializer.fromJsonRacket(maps[i]);
    });
  }

  // Limpiar la base de datos
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('rackets');
  }

  // Añadir una columna nueva (si es necesario)
  Future<void> addColumn() async {
    final db = await database;
    await db.execute('''
      ALTER TABLE rackets ADD COLUMN isSelected INTEGER DEFAULT 0
    ''');
  }

  // Actualizar una raqueta
  Future<int> updateRacket(Racket racket) async {
    final db = await database;
    return await db.update(
      'rackets',
      RacketSerializer.toJsonRacket(racket), 
      where: 'id = ?',
      whereArgs: [racket.id],
    );
  }

  // Eliminar una raqueta
  Future<int> deleteRacket(int id) async {
    final db = await database;
    return await db.delete(
      'rackets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<void> insertRacketList(List<Racket> rackets, {Database? dbInstance}) async {
    final db = dbInstance ?? await database;
    await checkTableStructure();
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var racket in rackets) {
        batch.insert('rackets', RacketSerializer.toJsonRacket(racket)); 
      }
      await batch.commit(noResult: true);
    });
  }

  // Seleccionar una raqueta
  Future<void> selectRacket(int racketId) async {
    final db = await database;

    await db.update('rackets', {'isSelected': 0});

    await db.update(
      'rackets',
      {'isSelected': 1},
      where: 'id = ?',
      whereArgs: [racketId],
    );
  }


  Future<void> deselectAllRackets() async {
    final db = await database;

    await db.update(
      'rackets',
      {'isSelected': 0}, 
    );
  }

  Future<Racket?> getSelectedRacket() async {
    final db = await database;

    final result = await db.query(
      'rackets',
      where: 'isSelected = ?',
      whereArgs: [1],
    );

    if (result.isNotEmpty) {
      return RacketSerializer.fromJsonRacket(result.first); 
    }
    return null;
  }
  //debug
  Future<void> checkTableStructure() async {
    final db = await database;
    List<Map> columns = await db.rawQuery('PRAGMA table_info(rackets);');
    print('columnas');
    print(columns);
  }

  Future<void> checkAndDeleteDB() async {
    final storage = FlutterSecureStorage();
    final firstRun = await storage.read(key: "db_deleted");

    if (firstRun == null) {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'app_database.db');

      if (await databaseExists(path)) {
        await deleteDatabase(path);
        print("Base de datos eliminada en el primer arranque.");
      }

      await storage.write(key: "db_deleted", value: "true");
    }
  }

}
