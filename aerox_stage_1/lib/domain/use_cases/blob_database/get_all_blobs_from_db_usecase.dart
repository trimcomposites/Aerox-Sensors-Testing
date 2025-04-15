
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/repository/blob_repository.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllBlobsFromDbUsecase extends AsyncUseCaseWithoutParams<List<List<Map<String, dynamic>>>>{

  final BlobRepository blobRepository;

  GetAllBlobsFromDbUsecase({required this.blobRepository});
  @override
  Future<EitherErr<List<List<Map<String, dynamic>>>>> call( ) async {
    return blobRepository.getAllBlobsFromDB();

  } 


}