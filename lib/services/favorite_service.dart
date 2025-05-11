import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/kosan.dart';

class FavoriteService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user ID or return empty string if not logged in
  String get _userId => _auth.currentUser?.uid ?? '';

  // Reference to the favorites collection for the current user
  CollectionReference get _favoritesRef =>
      _firestore.collection('users').doc(_userId).collection('favorites');

  // Add a property to favorites
  Future<void> addToFavorites(Kosan kosan) async {
    if (_userId.isEmpty) return;

    await _favoritesRef.doc(kosan.id).set(kosan.toMap());
  }

  // Remove a property from favorites
  Future<void> removeFromFavorites(String kosanId) async {
    if (_userId.isEmpty) return;

    await _favoritesRef.doc(kosanId).delete();
  }

  // Check if a property is in favorites
  Future<bool> isFavorite(String kosanId) async {
    if (_userId.isEmpty) return false;

    final doc = await _favoritesRef.doc(kosanId).get();
    return doc.exists;
  }

  // Get all favorite properties
  Stream<List<Kosan>> getFavorites() {
    if (_userId.isEmpty) return Stream.value([]);

    return _favoritesRef.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) =>
                    Kosan.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList(),
    );
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(Kosan kosan) async {
    if (_userId.isEmpty) return false;

    final isCurrentlyFavorite = await isFavorite(kosan.id);

    if (isCurrentlyFavorite) {
      await removeFromFavorites(kosan.id);
      return false;
    } else {
      await addToFavorites(kosan);
      return true;
    }
  }
}
