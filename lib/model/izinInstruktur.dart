// To parse this JSON data, do
//
//     final izinInstruktur = izinInstrukturFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'instruktur.dart';
import 'jadwalHarian.dart';

List<IzinInstruktur> izinInstrukturFromJson(String str) => List<IzinInstruktur>.from(json.decode(str).map((x) => IzinInstruktur.fromJson(x)));

String izinInstrukturToJson(List<IzinInstruktur> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IzinInstruktur {
    int? id;
    String idInstruktur;
    String idInstrukturPengganti;
    String idJadwalHarian;
    String statusInstruktur;
    DateTime? waktuPerizinan;
    String? confirm;
    DateTime createdAt;
    DateTime updatedAt;
    Instruktur instruktur;
    Instruktur instrukturpengganti;
    JadwalHarian jadwalHarian;

    IzinInstruktur({
        this.id,
        required this.idInstruktur,
        required this.idInstrukturPengganti,
        required this.idJadwalHarian,
        required this.statusInstruktur,
        this.waktuPerizinan,
        this.confirm,
        required this.createdAt,
        required this.updatedAt,
        required this.instruktur,
        required this.instrukturpengganti,
        required this.jadwalHarian,
    });

    factory IzinInstruktur.fromJson(Map<String, dynamic> json) => IzinInstruktur(
        id: json["id"],
        idInstruktur: json["id_instruktur"],
        idInstrukturPengganti: json["id_instruktur_pengganti"],
        idJadwalHarian: json["id_jadwal_harian"],
        statusInstruktur: json["status_instruktur"],
        waktuPerizinan: json["waktu_perizinan"] == null ? null : DateTime.parse(json["waktu_perizinan"]),
        confirm: json["confirm"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        instruktur: Instruktur.fromJson(json["instruktur"]),
        instrukturpengganti: Instruktur.fromJson(json["instrukturpengganti"]),
        jadwalHarian: JadwalHarian.fromJson(json["jadwal_harian"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_instruktur": idInstruktur,
        "id_instruktur_pengganti": idInstrukturPengganti,
        "id_jadwal_harian": idJadwalHarian,
        "status_instruktur": statusInstruktur,
        "waktu_perizinan": waktuPerizinan?.toIso8601String(),
        "confirm": confirm,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "instruktur": instruktur.toJson(),
        "instrukturpengganti": instrukturpengganti.toJson(),
        "jadwal_harian": jadwalHarian.toJson(),
    };
}