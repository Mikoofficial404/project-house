import 'package:cloud_firestore/cloud_firestore.dart';

class StorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> saveImageReference(String imageUrl) async {
    try {
      String validatedUrl = await validateImageUrl(imageUrl);
      
      await _firestore.collection('image_references').add({
        'url': validatedUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      return validatedUrl;
    } catch (e) {
      throw Exception('Failed to save image reference: $e');
    }
  }

  Future<String> validateImageUrl(String imageUrl) async {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    } else {
      throw Exception('Invalid image URL format');
    }
  }
}
