// import 'package:aerox_stage_1/domain/models/blob.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class BlobsSQLiteDB {
//   static final BlobsSQLiteDB _instance = BlobsSQLiteDB._internal();
//   static Database? _database;

//   factory BlobsSQLiteDB() => _instance;
//   BlobsSQLiteDB._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     final databasesPath = await getDatabasesPath();
//     final path = join(databasesPath, 'app_database.db');

//     _database = await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//     return _database!;
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE blobs (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         address INTEGER,
//         blobType INTEGER,
//         blobNumPackets INTEGER,
//         blobSize INTEGER,
//         extraDataLen INTEGER,
//         extraData TEXT,
//         createdAt TEXT,
//         closedAt TEXT
//       );
//     ''');

//     await db.execute('''
//       CREATE TABLE blob_packets (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         blobId INTEGER,
//         address INTEGER,
//         dataAddress INTEGER,
//         packetType INTEGER,
//         blobType INTEGER,
//         packetSize INTEGER,
//         timestamp INTEGER,
//         ms INTEGER,
//         createdAt TEXT,
//         timestampClosed INTEGER,
//         msClosed INTEGER,
//         closedAt TEXT,
//         packetData TEXT,
//         FOREIGN KEY (blobId) REFERENCES blobs(id) ON DELETE CASCADE
//       );
//     ''');
//   }
//   //INSERTAR BLOB CON PAQUETES 
//     Future<void> insertBlobWithPackets(Blob blob) async {
//     final db = await database;

//     final blobId = await db.insert('blobs', {
//       'address': blob.address,
//       'blobType': blob.blobType,
//       'blobNumPackets': blob.blobNumPackets,
//       'blobSize': blob.blobSize,
//       'extraDataLen': blob.extraDataLen,
//       'extraData': blob.extraData.join(','),
//       'createdAt': blob.createdAt?.toIso8601String(),
//       'closedAt': blob.closedAt?.toIso8601String(),
//     });

//     for (var packet in blob.packets) {
//       await db.insert('packets', {
//         'blobId': blobId,
//         'address': packet.packetInfo.address,
//         'dataAddress': packet.packetInfo.dataAddress,
//         'packetType': packet.packetInfo.packetType,
//         'blobType': packet.packetInfo.blobType,
//         'packetSize': packet.packetInfo.packetSize,
//         'timestamp': packet.packetInfo.timestamp,
//         'ms': packet.packetInfo.ms,
//         'createdAt': packet.packetInfo.createdAt.toIso8601String(),
//         'timestampClosed': packet.packetInfo.timestampClosed,
//         'msClosed': packet.packetInfo.msClosed,
//         'closedAt': packet.packetInfo.closedAt.toIso8601String(),
//         'packetData': packet.packetData.join(',')
//       });
//     }
//   }
//   Future<List<Blob>> getAllBlobsWithPackets() async {
//     final db = await database;

//     final blobRows = await db.query('blobs');

//     List<Blob> blobs = [];

//     for (var blobMap in blobRows) {
//       final blobId = blobMap['id'] as int;

//       final packetRows = await db.query('packets', where: 'blobId = ?', whereArgs: [blobId]);

//       final packets = packetRows.map((p) {
//         return BlobPacket(
//           packetInfo: PacketInfo(
//             address: p['address'] as int,
//             dataAddress: p['dataAddress'] as int,
//             packetType: p['packetType'] as int,
//             blobType: p['blobType'] as int,
//             packetSize: p['packetSize'] as int,
//             timestamp: p['timestamp'] as int,
//             ms: p['ms'] as int,
//             createdAt: DateTime.parse(p['createdAt'] as String),
//             timestampClosed: p['timestampClosed'] as int,
//             msClosed: p['msClosed'] as int,
//             closedAt: DateTime.parse(p['closedAt'] as String),
//           ),
//           packetData: (p['packetData'] as String).split(',').map(int.parse).toList(),
//         );
//       }).toList();

//       blobs.add(
//         Blob(
//           address: blobMap['address'] as int,
//           blobType: blobMap['blobType'] as int,
//           blobNumPackets: blobMap['blobNumPackets'] as int,
//           blobSize: blobMap['blobSize'] as int,
//           extraDataLen: blobMap['extraDataLen'] as int,
//           extraData: (blobMap['extraData'] as String).split(',').map(int.parse).toList(),
//           packets: packets,
//           createdAt: blobMap['createdAt'] != null ? DateTime.parse(blobMap['createdAt'] as String) : null,
//           closedAt: blobMap['closedAt'] != null ? DateTime.parse(blobMap['closedAt'] as String) : null,
//         ),
//       );
//     }

//     return blobs;
//   }

// Future<int> deleteBlob(int address) async {
//   final db = await database;

//   // Opcional: eliminar primero los paquetes relacionados
//   await db.delete(
//     'blob_packets',
//     where: 'blob_address = ?',
//     whereArgs: [address],
//   );

//   return await db.delete(
//     'blobs',
//     where: 'address = ?',
//     whereArgs: [address],
//   );
// }



// }
