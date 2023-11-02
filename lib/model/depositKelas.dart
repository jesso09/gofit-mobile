// To parse this JSON data, do
//
//     final depositKelas = depositKelasFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'kelas.dart';
import 'member.dart';
import 'pegawai.dart';

List<DepositKelas> depositKelasFromJson(String str) => List<DepositKelas>.from(json.decode(str).map((x) => DepositKelas.fromJson(x)));

String depositKelasToJson(List<DepositKelas> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DepositKelas {
    int id;
    String nomorTransaksi;
    String idPegawai;
    String idMember;
    String idKelas;
    String depositKelas;
    DateTime masaBerlaku;
    String totalHargaKelas;
    DateTime createdAt;
    DateTime updatedAt;
    Member member;
    Pegawai pegawai;
    Kelas kelas;

    DepositKelas({
        required this.id,
        required this.nomorTransaksi,
        required this.idPegawai,
        required this.idMember,
        required this.idKelas,
        required this.depositKelas,
        required this.masaBerlaku,
        required this.totalHargaKelas,
        required this.createdAt,
        required this.updatedAt,
        required this.member,
        required this.pegawai,
        required this.kelas,
    });

    factory DepositKelas.fromJson(Map<String, dynamic> json) => DepositKelas(
        id: json["id"],
        nomorTransaksi: json["nomor_transaksi"],
        idPegawai: json["id_pegawai"],
        idMember: json["id_member"],
        idKelas: json["id_kelas"],
        depositKelas: json["deposit_kelas"],
        masaBerlaku: DateTime.parse(json["masa_berlaku"]),
        totalHargaKelas: json["total_harga_kelas"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        member: Member.fromJson(json["member"]),
        pegawai: Pegawai.fromJson(json["pegawai"]),
        kelas: Kelas.fromJson(json["kelas"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nomor_transaksi": nomorTransaksi,
        "id_pegawai": idPegawai,
        "id_member": idMember,
        "id_kelas": idKelas,
        "deposit_kelas": depositKelas,
        "masa_berlaku": "${masaBerlaku.year.toString().padLeft(4, '0')}-${masaBerlaku.month.toString().padLeft(2, '0')}-${masaBerlaku.day.toString().padLeft(2, '0')}",
        "total_harga_kelas": totalHargaKelas,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "member": member.toJson(),
        "pegawai": pegawai.toJson(),
        "kelas": kelas.toJson(),
    };
}