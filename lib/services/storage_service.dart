// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';

// class StorageService {
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<String> uploadImage(File imageFile) async {
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference ref = _storage.ref().child('kosan_images').child(fileName);
//     UploadTask uploadTask = ref.putFile(imageFile);
//     TaskSnapshot snapshot = await uploadTask;
//     return await snapshot.ref.getDownloadURL();
//   }
// }
