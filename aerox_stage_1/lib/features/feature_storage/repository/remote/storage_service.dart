import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class StorageService {
  final FirebaseStorage storage;

  StorageService({FirebaseStorage? instance})
      : storage = instance ?? FirebaseStorage.instance;

  Future<String> uploadFile(File file, {String? path}) async {
    final fileName = basename(file.path);
    final uploadPath = path != null ? '$path/$fileName' : 'uploads/$fileName';

    final ref = storage.ref(uploadPath);
    final uploadTask = ref.putFile(file);
    await uploadTask;

    final downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }
}
