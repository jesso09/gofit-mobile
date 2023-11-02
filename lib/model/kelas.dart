// To parse this JSON data, do
//
//     final kelas = kelasFromJson(jsonString);

import 'dart:convert';

List<Kelas> kelasFromJson(String str) => List<Kelas>.from(json.decode(str).map((x) => Kelas.fromJson(x)));

String kelasToJson(List<Kelas> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Kelas {
    int id;
    String idInstruktur;
    String idDetailKelas;
    String namaKelas;
    String waktuMulai;
    String waktuSelesai;
    String kapasitas;
    DateTime createdAt;
    DateTime updatedAt;
    ClassDetail classDetail;

    Kelas({
        required this.id,
        required this.idInstruktur,
        required this.idDetailKelas,
        required this.namaKelas,
        required this.waktuMulai,
        required this.waktuSelesai,
        required this.kapasitas,
        required this.createdAt,
        required this.updatedAt,
        required this.classDetail,
    });

    factory Kelas.fromJson(Map<String, dynamic> json) => Kelas(
        id: json["id"],
        idInstruktur: json["id_instruktur"],
        idDetailKelas: json["id_detail_kelas"],
        namaKelas: json["nama_kelas"],
        waktuMulai: json["waktu_mulai"],
        waktuSelesai: json["waktu_selesai"],
        kapasitas: json["kapasitas"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        classDetail: ClassDetail.fromJson(json["class_detail"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_instruktur": idInstruktur,
        "id_detail_kelas": idDetailKelas,
        "nama_kelas": namaKelas,
        "waktu_mulai": waktuMulai,
        "waktu_selesai": waktuSelesai,
        "kapasitas": kapasitas,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "class_detail": classDetail.toJson(),
    };
}

class ClassDetail {
    int id;
    String sesi;
    String harga;
    DateTime? createdAt;
    DateTime? updatedAt;

    ClassDetail({
        required this.id,
        required this.sesi,
        required this.harga,
        this.createdAt,
        this.updatedAt,
    });

    factory ClassDetail.fromJson(Map<String, dynamic> json) => ClassDetail(
        id: json["id"],
        sesi: json["sesi"],
        harga: json["harga"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sesi": sesi,
        "harga": harga,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
