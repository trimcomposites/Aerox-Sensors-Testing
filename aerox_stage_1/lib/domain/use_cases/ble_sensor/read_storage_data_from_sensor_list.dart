import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/repository/local/blobs_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';

class ReadStorageDataFromSensorListUsecase extends AsyncUseCaseWithParams<void,  ReadBlobsFromSensorListParams>{

  final BleRepository bleRepository;
  final BlobSQLiteDB blobSQLiteDB; //TODO: DELETE, solo para mocks
  ReadStorageDataFromSensorListUsecase({required this.bleRepository, required this.blobSQLiteDB});
  @override
  Future<EitherErr<Map<RacketSensor, List<Blob>>>> call(ReadBlobsFromSensorListParams params) {
    return bleRepository.readBlobsFromSensorsList(
      sensors: params.sensors,
      maxParallel: params.maxParallel,
      onProgress: params.onProgress,
      onReadGlobal: params.onReadGlobal,
      onTotalGlobal: params.onTotalGlobal,
    );
  }
}

  class ReadBlobsFromSensorListParams {
  final List<RacketSensor> sensors;
  final int maxParallel;
  final void Function(RacketSensor sensor, int read, int total)? onProgress;
  final void Function(int)? onReadGlobal;
  final void Function(int)? onTotalGlobal;

  ReadBlobsFromSensorListParams({
    required this.sensors,
    this.maxParallel = 4,
    this.onProgress,
    this.onReadGlobal,
    this.onTotalGlobal,
  });
}
