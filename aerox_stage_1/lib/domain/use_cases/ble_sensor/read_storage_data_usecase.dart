
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/repository/local/blobs_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';
import 'package:dartz/dartz.dart';

class ReadStorageDataUsecase extends AsyncUseCaseWithParams<void,  RacketSensor>{

  final BleRepository bleRepository;
  final BlobSQLiteDB blobSQLiteDB; //TODO: DELETE, solo para mocks
  ReadStorageDataUsecase({required this.bleRepository, required this.blobSQLiteDB});
  @override
  Future<EitherErr<List<Blob>>> call( sensor ) async {
    
    final blobs = bleRepository.readAllBlobs( sensor );
    return blobs;
    // for( var blob in MockBlobs.mockBlobs ){
    //   final exists = await blobSQLiteDB.existsBlob(blob.createdAt!);
    //   if (!exists) {
    //     final parsed = await bleRepository.parseBlob(blob);
    //     parsed.fold(
    //       (_) => null,
    //       (parsedData) => blobSQLiteDB.insertParsedBlob(blob.createdAt!, parsedData),
    //     );//TODO: REMOVE FOLD
    //   }
    // }
    // return Right(MockBlobs.mockBlobs);

  } 


}class MockBlobs {
  static List<Blob> mockBlobs = <Blob>[
    Blob(
      blobInfo: BlobInfo(
        address: 0x1000,
        blobType: 1,
        blobNumPackets: 2,
        blobSize: 128,
        extraDataLen: 3,
        extraData: [0x01, 0x01, 0x06],
      ),
      packets: [
        BlobPacket(
          packetInfo: PacketInfo(
            address: 0x1000,
            dataAddress: 0x100C,
            packetType: 1,
            blobType: 1,
            packetSize: 64,
            timestamp: 1672574400,
            ms: 123,
            createdAt: DateTime.utc(2023, 1, 1, 10, 0, 0),
            timestampClosed: 1672574402,
            msClosed: 456,
            closedAt: DateTime.utc(2023, 1, 1, 10, 0, 2),
          ),
          packetData: List<int>.generate(48, (i) => i % 256),
        ),
        BlobPacket(
          packetInfo: PacketInfo(
            address: 0x1040,
            dataAddress: 0x104C,
            packetType: 1,
            blobType: 1,
            packetSize: 64,
            timestamp: 1672574410,
            ms: 123,
            createdAt: DateTime.utc(2023, 1, 1, 10, 0, 10),
            timestampClosed: 1672574412,
            msClosed: 456,
            closedAt: DateTime.utc(2023, 1, 1, 10, 0, 12),
          ),
          packetData: List<int>.generate(48, (i) => (i + 1) % 256),
        ),
      ],
      createdAt: DateTime.utc(2023, 1, 1, 10, 0, 0),
      closedAt: DateTime.utc(2023, 1, 1, 10, 0, 20),
    ),
    Blob(
      blobInfo: BlobInfo(
        address: 0x2000,
        blobType: 1,
        blobNumPackets: 2,
        blobSize: 128,
        extraDataLen: 3,
        extraData: [0x01, 0x01, 0x06],
      ),
      packets: [
        BlobPacket(
          packetInfo: PacketInfo(
            address: 0x2000,
            dataAddress: 0x200C,
            packetType: 1,
            blobType: 1,
            packetSize: 64,
            timestamp: 1672574500,
            ms: 123,
            createdAt: DateTime.utc(2023, 2, 2, 12, 0, 0),
            timestampClosed: 1672574502,
            msClosed: 456,
            closedAt: DateTime.utc(2023, 2, 2, 12, 0, 2),
          ),
          packetData: List<int>.generate(48, (i) => i % 256),
        ),
        BlobPacket(
          packetInfo: PacketInfo(
            address: 0x2040,
            dataAddress: 0x204C,
            packetType: 1,
            blobType: 1,
            packetSize: 64,
            timestamp: 1672574510,
            ms: 123,
            createdAt: DateTime.utc(2023, 2, 2, 12, 0, 10),
            timestampClosed: 1672574512,
            msClosed: 456,
            closedAt: DateTime.utc(2023, 2, 2, 12, 0, 12),
          ),
          packetData: List<int>.generate(48, (i) => (i + 1) % 256),
        ),
      ],
      createdAt: DateTime.utc(2023, 2, 2, 12, 0, 0),
      closedAt: DateTime.utc(2023, 2, 2, 12, 0, 20),
    ),
    Blob(
      blobInfo: BlobInfo(
        address: 0x3000,
        blobType: 1,
        blobNumPackets: 2,
        blobSize: 128,
        extraDataLen: 3,
        extraData: [0x01, 0x01, 0x06],
      ),
      packets: [
        BlobPacket(
          packetInfo: PacketInfo(
            address: 0x3000,
            dataAddress: 0x300C,
            packetType: 1,
            blobType: 1,
            packetSize: 64,
            timestamp: 1672574600,
            ms: 123,
            createdAt: DateTime.utc(2023, 3, 3, 13, 0, 0),
            timestampClosed: 1672574602,
            msClosed: 456,
            closedAt: DateTime.utc(2023, 3, 3, 13, 0, 2),
          ),
          packetData: List<int>.generate(48, (i) => i % 256),
        ),
        BlobPacket(
          packetInfo: PacketInfo(
            address: 0x3040,
            dataAddress: 0x304C,
            packetType: 1,
            blobType: 1,
            packetSize: 64,
            timestamp: 1672574610,
            ms: 123,
            createdAt: DateTime.utc(2023, 3, 3, 13, 0, 10),
            timestampClosed: 1672574612,
            msClosed: 456,
            closedAt: DateTime.utc(2023, 3, 3, 13, 0, 12),
          ),
          packetData: List<int>.generate(48, (i) => (i + 1) % 256),
        ),
      ],
      createdAt: DateTime.utc(2023, 3, 3, 13, 0, 0),
      closedAt: DateTime.utc(2023, 3, 3, 13, 0, 20),
    ),
    Blob(
      blobInfo: BlobInfo(
        address: 0x4000,
        blobType: 1,
        blobNumPackets: 1,
        blobSize: 64,
        extraDataLen: 3,
        extraData: [0x01, 0x01, 0x06],
      ),
      packets: [
        BlobPacket(
          packetInfo: PacketInfo(
            address: 0x4000,
            dataAddress: 0x400C,
            packetType: 1,
            blobType: 1,
            packetSize: 64,
            timestamp: 1672574720,
            ms: 200,
            createdAt: DateTime.utc(2023, 2, 2, 15, 0, 0),
            timestampClosed: 1672574722,
            msClosed: 300,
            closedAt: DateTime.utc(2023, 2, 2, 15, 0, 2),
          ),
          packetData: List<int>.generate(48, (i) => (255 - i) % 256),
        ),
      ],
      createdAt: DateTime.utc(2023, 2, 2, 15, 0, 0),
      closedAt: DateTime.utc(2023, 2, 2, 15, 0, 2),
    ),
  ];
}
