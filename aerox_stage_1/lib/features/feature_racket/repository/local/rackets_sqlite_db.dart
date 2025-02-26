import 'dart:async';
import 'dart:io';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aerox_stage_1/domain/models/racket_serializer.dart';

class RacketsSQLiteDB {
  static final RacketsSQLiteDB _instance = RacketsSQLiteDB._internal();
  static Database? _database;


  factory RacketsSQLiteDB() {
    return _instance;
  }

  RacketsSQLiteDB._internal();

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
      id INTEGER PRIMARY KEY,
      hit TEXT NOT NULL,
      racket TEXT NOT NULL,
      racketName TEXT NOT NULL,
      color TEXT NOT NULL,
      weightNumber TEXT NOT NULL,
      weightUnit TEXT NOT NULL,
      weightType TEXT NOT NULL,
      balance TEXT NOT NULL,
      headType TEXT NOT NULL,
      swingWeight TEXT NOT NULL,
      powerType TEXT NOT NULL,
      acor TEXT NOT NULL,
      acorType TEXT NOT NULL,
      maneuverability TEXT NOT NULL,
      maneuverabilityType TEXT NOT NULL,
      image TEXT NOT NULL,
      weightMin TEXT NOT NULL,
      weightMax TEXT NOT NULL,
      balanceMin TEXT NOT NULL,
      balanceMax TEXT NOT NULL,
      swingWeightMin TEXT NOT NULL,
      swingWeightMax TEXT NOT NULL,
      maneuverabilityMin TEXT NOT NULL,
      maneuverabilityMax TEXT NOT NULL,
      acorMin TEXT NOT NULL,
      acorMax TEXT NOT NULL,
      isSelected INTEGER DEFAULT 0
    )
  ''');
  // await insertRacketList(mockRackets, dbInstance: db); // Temp data
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
      await upsertRacket(racket, txn, batch);
    }

    await batch.commit(noResult: true);
  });
}

Future<void> upsertRacket(Racket racket, Transaction txn, Batch batch) async {
  final existingRacket = await checkRacketExistence(racket.id, txn);

  if (existingRacket.isEmpty) {
    insertMyRacket(racket, batch);
  } else {
    updateMyRacket(racket, txn, batch);
  }
}

Future<List<Map<String, dynamic>>> checkRacketExistence(int id, Transaction txn) async {
  return await txn.query(
    'rackets',
    where: 'id = ?',
    whereArgs: [id],
  );
}

void insertMyRacket(Racket racket, Batch batch) {
  batch.insert('rackets', RacketSerializer.toJsonRacket(racket));
}

void updateMyRacket(Racket racket, Transaction txn, Batch batch) {
  batch.update(
    'rackets',
    RacketSerializer.toJsonRacket(racket),
    where: 'id = ?',
    whereArgs: [racket.id],
  );
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
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS rackets');

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
