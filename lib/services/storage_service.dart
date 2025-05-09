import 'package:cloud_firestore/cloud_firestore.dart';

class StorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Since we don't have Firebase Storage, we can't upload files directly
  // Instead, we'll store external image URLs in Firestore
  Future<String> saveImageReference(String imageUrl) async {
    try {
      // Validate the URL first
      String validatedUrl = await validateImageUrl(imageUrl);
      
      // Store the reference in Firestore if needed
      // This is optional - you might just want to use the URL directly in your app
      await _firestore.collection('image_references').add({
        'url': validatedUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      return validatedUrl;
    } catch (e) {
      throw Exception('Failed to save image reference: $e');
    }
  }

  // Method to validate an external image URL
  Future<String> validateImageUrl(String imageUrl) async {
    // Simple validation to check if it's a valid URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    } else {
      throw Exception('Invalid image URL format');
    }
  }
}
