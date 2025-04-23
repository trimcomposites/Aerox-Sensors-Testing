
import 'dart:io';

import 'package:aerox_stage_1/common/utils/typedef.dart';

import 'package:aerox_stage_1/domain/models/parsed_blob.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';
import 'package:aerox_stage_1/features/feature_storage/repository/upload_repository.dart';

class UploadBlobsToStorageUsecase extends AsyncUseCaseWithParams<void,  List<File>>{

  final UploadRepository uploadRepository;

  UploadBlobsToStorageUsecase({required this.uploadRepository});
  @override
  Future<EitherErr<void>> call( blobs ) async {
    
    final result = await uploadRepository.uplaoadFileList(  blobs );
    return result;

  } 


}