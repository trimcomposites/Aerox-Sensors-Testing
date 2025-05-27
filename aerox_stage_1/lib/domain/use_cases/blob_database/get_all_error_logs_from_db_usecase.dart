
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/error_log.dart';
import 'package:aerox_stage_1/domain/models/parsed_blob.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/repository/blob_repository.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllErrorLogsFromDbUsecase extends AsyncUseCaseWithoutParams<List<ErrorLog>>{

  final BlobRepository blobRepository;

  GetAllErrorLogsFromDbUsecase({required this.blobRepository});
  @override
  Future<EitherErr<List<ErrorLog>>> call( ) async {
    return blobRepository.getErrorLogsFromDB();

  } 


}