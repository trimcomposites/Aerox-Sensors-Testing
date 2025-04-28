import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class StorageService {
  final FirebaseStorage storage;

  StorageService({FirebaseStorage? instance})
      : storage = instance ?? FirebaseStorage.instance;

  Future<String> uploadFile(File file, {String? path}) async {
  final randomSuffix = Random.secure().nextInt(1 << 10); 
  final fileName = '${basenameWithoutExtension(file.path)}_$randomSuffix${extension(file.path)}';

    final uploadPath = path != null ? '$path/$fileName' : 'uploads/$fileName';

    final ref = storage.ref(uploadPath);
    final uploadTask = ref.putFile(file);
    await uploadTask;

    final downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }
}
