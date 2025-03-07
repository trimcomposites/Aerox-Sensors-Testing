import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadFile {
Future<String> downloadFile(String fileUrl, String name) async {
    try {
      //if (await _requestPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$name';
        
        Dio dio = Dio();

        final result = await dio.download(fileUrl, filePath, onReceiveProgress: (int received, int total) {
          if (total != -1) {
            print('Descargando: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        });
        
        print('Archivo descargado en: $filePath');

        String content = await readFile(filePath);
        print('Contenido del archivo: $content');

        return filePath;
      ////return 'Permiso denegado';
      //}
    } catch (e) {
      print("Error descargando el archivo: $e");
      return ''; 
    }
  }

  Future<bool> _requestPermission() async {

    PermissionStatus status = await Permission.storage.request();
    
    return status.isGranted;
    

  }

  Future<String> readFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return "El archivo no existe";
      }
      return await file.readAsString();
    } catch (e) {
      return "Error al leer el archivo: $e";
    }
  }
}
Future<String> readFile(String filePath) async {
  try {
    final file = File(filePath);

    if (!await file.exists()) {
      return "El archivo no existe";
    }


    final bytes = await file.readAsBytes();

    return 'Tamaño del archivo: ${bytes.length} bytes';
  } catch (e) {
    return "Error al leer el archivo: $e";
  }
}
