import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Penghasilan {
  final int? id;
  final String sumber;
  final double jumlah;
  final String tanggal;
  Penghasilan({
    this.id,
    required this.sumber,
    required this.jumlah,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sumber': sumber,
      'jumlah': jumlah,
      'tanggal': tanggal,
    };
  }

  factory Penghasilan.fromMap(Map<String, dynamic> map) {
    return Penghasilan(
      id: map['id'] != null ? map['id'] as int : null,
      sumber: map['sumber'] as String,
      jumlah: map['jumlah'] as double,
      tanggal: map['tanggal'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Penghasilan.fromJson(String source) =>
      Penghasilan.fromMap(json.decode(source) as Map<String, dynamic>);
}
