import 'dart:io';

import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/features/feature_storage/repository/remote/storage_service.dart';


class UploadRepository {
  final StorageService storageUploadService;

  UploadRepository({required this.storageUploadService});

  Future<EitherErr<void>> uplaoadFileList(List<File> files, {String? path}) {
    return EitherCatch.catchAsync<void, BluetoothErr>(() async {

      for( File file in files ){
        final url = await storageUploadService.uploadFile(file, path: path);
        print('✅ Archivo subido. URL: $url');
      }
      
    }, (e) {
      return BluetoothErr(
        errMsg: 'Error al subir archivo: ${e.toString()}',
        statusCode: 500,
      );
    });
  }
}
