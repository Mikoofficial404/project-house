import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PemilikModel {
  final String noKtp;
  final String nama;
  final String email;
  final String noHp;
  PemilikModel({
    required this.noKtp,
    required this.nama,
    required this.email,
    required this.noHp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'noKtp': noKtp,
      'nama': nama,
      'noHp' : noHp,
      'email': email,
    };
  }

  factory PemilikModel.fromMap(Map<String, dynamic> map) {
    return PemilikModel(
      noKtp: map['noKtp'] as String,
      nama: map['nama'] as String,
      noHp: map['noHp'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PemilikModel.fromJson(String source) => PemilikModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
