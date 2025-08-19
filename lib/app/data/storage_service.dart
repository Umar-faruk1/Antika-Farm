import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static Future<String> uploadFile(File file, String folderName) async {
    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.isNotEmpty ? file.uri.pathSegments.last : 'image.jpg'}';
    final Reference ref = FirebaseStorage.instance.ref().child('$folderName/$fileName');
    final UploadTask uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() {});
    return await ref.getDownloadURL();
  }
}


