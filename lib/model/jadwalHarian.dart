// To parse this JSON data, do
//
//     final jadwalHarian = jadwalHarianFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'instruktur.dart';
import 'kelas.dart';

List<JadwalHarian> jadwalHarianFromJson(String str) => List<JadwalHarian>.from(json.decode(str).map((x) => JadwalHarian.fromJson(x)));

String jadwalHarianToJson(List<JadwalHarian> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JadwalHarian {
    int id;
    String idInstruktur;
    String idKelas;
    String hari;
    String sesi;
    String waktuMulai;
    String waktuSelesai;
    DateTime tanggal;
    String statusKelas;
    DateTime createdAt;
    DateTime updatedAt;
    Kelas kelas;
    Instruktur instruktur;

    JadwalHarian({
        required this.id,
        required this.idInstruktur,
        required this.idKelas,
        required this.hari,
        required this.sesi,
        required this.waktuMulai,
        required this.waktuSelesai,
        required this.tanggal,
        required this.statusKelas,
        required this.createdAt,
        required this.updatedAt,
        required this.kelas,
        required this.instruktur,
    });

    factory JadwalHarian.fromJson(Map<String, dynamic> json) => JadwalHarian(
        id: json["id"],
        idInstruktur: json["id_instruktur"],
        idKelas: json["id_kelas"],
        hari: json["hari"],
        sesi: json["sesi"],
        waktuMulai: json["waktu_mulai"],
        waktuSelesai: json["waktu_selesai"],
        tanggal: DateTime.parse(json["tanggal"]),
        statusKelas: json["status_kelas"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        kelas: Kelas.fromJson(json["kelas"]),
        instruktur: Instruktur.fromJson(json["instruktur"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_instruktur": idInstruktur,
        "id_kelas": idKelas,
        "hari": hari,
        "sesi": sesi,
        "waktu_mulai": waktuMulai,
        "waktu_selesai": waktuSelesai,
        "tanggal": "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "status_kelas": statusKelas,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "kelas": kelas.toJson(),
        "instruktur": instruktur.toJson(),
    };
}