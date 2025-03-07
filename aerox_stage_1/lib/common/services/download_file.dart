import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadFile {
  Future<String> downloadFile(String fileUrl, String name) async {
    try {

      PermissionStatus status = await Permission.accessMediaLocation.request();
      
      if (status.isGranted) {
        print('Permiso concedido, comenzando la descarga...');

        // Obtener el directorio de documentos en el dispositivo
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${name}';  

        // Crear la instancia de Dio para la descarga
        Dio dio = Dio();

        // Realizar la descarga
        final result =await dio.download(fileUrl, filePath, onReceiveProgress: (int param1,int param2)=> {
              
        });
        final fileDownloaded =new File(filePath);
        print('Archivo descargado en: ' + filePath + fileDownloaded.toString());

      try {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('$directory/$filePath');
    
        if (!await file.exists()) {
          return "El archivo no existe";
        }
    
        return await file.readAsString();
      } catch (e) {
        print( "Error al leer el archivo: $e");
      }
       return filePath; // Devolver la ruta del archivo descargado
      } else {
        print("Permiso denegado. No se puede descargar el archivo.");
        return ''; // Si el permiso es denegado, devolver un string vacío
      }
    } catch (e) {
      print("Error descargando el archivo: $e");
      return '';  // Devolver un string vacío si ocurre un error
    }
  }
}
