class Kosan {
  String id;
  String imageUrl;
  String deskripsi;
  String lokasi;
  int harga;
  List<dynamic> fasilitas;

  Kosan({
    required this.id,
    required this.imageUrl,
    required this.deskripsi,
    required this.lokasi,
    required this.harga,
    required this.fasilitas,
  });

  factory Kosan.fromMap(Map<String, dynamic> data, String documentId) {
    return Kosan(
      id: documentId,
      imageUrl: data['imageUrl'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      lokasi: data['lokasi'] ?? '',
      harga: data['harga'] ?? 0,
      fasilitas: data['fasilitas'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
      'harga': harga,
      'fasilitas': fasilitas,
    };
  }
}
