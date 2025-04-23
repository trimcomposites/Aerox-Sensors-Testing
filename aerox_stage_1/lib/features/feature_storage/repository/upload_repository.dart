import 'dart:io';

import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/features/feature_storage/repository/remote/storage_service.dart';


class UploadRepository {
  final StorageService storageUploadService;

  UploadRepository({required this.storageUploadService});


  Future<EitherErr<void>> uploadFileListWithPaths(List<FileWithPath> filesWithPaths) {
    return EitherCatch.catchAsync<void, BluetoothErr>(() async {
      for (final item in filesWithPaths) {
        final url = await storageUploadService.uploadFile(item.file, path: item.path);
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
class FileWithPath {
  final File file;
  final String path;

  FileWithPath({required this.file, required this.path});
}
