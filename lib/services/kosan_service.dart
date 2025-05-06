import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kosan.dart';

class KosanService {
  final CollectionReference _kosanRef = FirebaseFirestore.instance.collection(
    'kosan',
  );

  Future<void> createKosan(Kosan kosan) async {
    await _kosanRef.add(kosan.toMap());
  }

  Stream<List<Kosan>> getKosans() {
    return _kosanRef.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) =>
                    Kosan.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList(),
    );
  }

  Future<void> updateKosan(Kosan kosan) async {
    await _kosanRef.doc(kosan.id).update(kosan.toMap());
  }

  Future<void> deleteKosan(String id) async {
    await _kosanRef.doc(id).delete();
  }
}
