// To parse this JSON data, do
//
//     final instruktur = instrukturFromJson(jsonString);

import 'dart:convert';

List<Instruktur> instrukturFromJson(String str) => List<Instruktur>.from(json.decode(str).map((x) => Instruktur.fromJson(x)));

String instrukturToJson(List<Instruktur> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Instruktur {
    int id;
    String? idAbsenInstruktur;
    String namaInstruktur;
    String alamat;
    DateTime tglLahir;
    String gender;
    String noTelp;
    String email;
    String password;
    String keterlambatan;
    DateTime? createdAt;
    DateTime? updatedAt;

    Instruktur({
        required this.id,
        this.idAbsenInstruktur,
        required this.namaInstruktur,
        required this.alamat,
        required this.tglLahir,
        required this.gender,
        required this.noTelp,
        required this.email,
        required this.password,
        required this.keterlambatan,
        this.createdAt,
        this.updatedAt,
    });

    factory Instruktur.fromJson(Map<String, dynamic> json) => Instruktur(
        id: json["id"],
        idAbsenInstruktur: json["id_absen_instruktur"],
        namaInstruktur: json["nama_instruktur"],
        alamat: json["alamat"],
        tglLahir: DateTime.parse(json["tgl_lahir"]),
        gender: json["gender"],
        noTelp: json["no_telp"],
        email: json["email"],
        password: json["password"],
        keterlambatan: json["keterlambatan"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_absen_instruktur": idAbsenInstruktur,
        "nama_instruktur": namaInstruktur,
        "alamat": alamat,
        "tgl_lahir": "${tglLahir.year.toString().padLeft(4, '0')}-${tglLahir.month.toString().padLeft(2, '0')}-${tglLahir.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "no_telp": noTelp,
        "email": email,
        "password": password,
        "keterlambatan": keterlambatan,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}