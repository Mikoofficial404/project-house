class Kosan {
  String id;
  String imageUrl;
  String deskripsi;
  String lokasi;
  int harga;
  List<dynamic> fasilitas;
  int bedrooms;
  int bathrooms;
  int kitchens;
  double latitude;
  double longitude; 
  int noWa;
  bool isAvailable;

  Kosan({
    required this.id,
    required this.imageUrl,
    required this.deskripsi,
    required this.lokasi,
    required this.harga,
    required this.fasilitas,
    this.bedrooms = 2,
    this.bathrooms = 2,
    this.kitchens = 1,
    this.latitude = -6.200000,
    this.longitude = 106.816666,
    this.noWa = 0,
    this.isAvailable = true, 
  });

  factory Kosan.fromMap(Map<String, dynamic> data, String documentId) {
    return Kosan(
      id: documentId,
      imageUrl: data['imageUrl'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      lokasi: data['lokasi'] ?? '',
      harga: data['harga'] ?? 0,
      fasilitas: data['fasilitas'] ?? [],
      bedrooms: data['bedrooms'] ?? 2,
      bathrooms: data['bathrooms'] ?? 2,
      kitchens: data['kitchens'] ?? 1,
      latitude: data['latitude'] ?? -6.200000,
      longitude: data['longitude'] ?? 106.816666,
      noWa: data['noWa'] ?? 0,
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
      'harga': harga,
      'fasilitas': fasilitas,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'kitchens': kitchens,
      'latitude': latitude,
      'longitude': longitude,
      'noWa': noWa,
      'isAvailable': isAvailable,
    };
  }
}
