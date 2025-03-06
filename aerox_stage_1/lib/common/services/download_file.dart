import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFile {
  Future<String> downloadFile(String fileUrl, String name) async {
  try {
    print('fileUrl:'+ fileUrl);
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${name}.glb';  

    Dio dio = Dio();

    await dio.download(fileUrl, filePath);
    print( 'file path:' + filePath );

    return filePath;
  } catch (e) {
    print("Error downloading the file: $e");
    return '';  
  }
}
}
