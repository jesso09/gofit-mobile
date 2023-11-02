// To parse this JSON data, do
//
//     final depositCash = depositCashFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'pegawai.dart';

import 'member.dart';

List<DepositCash> depositCashFromJson(String str) => List<DepositCash>.from(json.decode(str).map((x) => DepositCash.fromJson(x)));

String depositCashToJson(List<DepositCash> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DepositCash {
    int id;
    String nomorTransaksi;
    String idPegawai;
    String idMember;
    String bonus;
    String jumlahDeposit;
    String total;
    DateTime createdAt;
    DateTime updatedAt;
    Member member;
    Pegawai pegawai;

    DepositCash({
        required this.id,
        required this.nomorTransaksi,
        required this.idPegawai,
        required this.idMember,
        required this.bonus,
        required this.jumlahDeposit,
        required this.total,
        required this.createdAt,
        required this.updatedAt,
        required this.member,
        required this.pegawai,
    });

    factory DepositCash.fromJson(Map<String, dynamic> json) => DepositCash(
        id: json["id"],
        nomorTransaksi: json["nomor_transaksi"],
        idPegawai: json["id_pegawai"],
        idMember: json["id_member"],
        bonus: json["bonus"],
        jumlahDeposit: json["jumlah_deposit"],
        total: json["total"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        member: Member.fromJson(json["member"]),
        pegawai: Pegawai.fromJson(json["pegawai"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nomor_transaksi": nomorTransaksi,
        "id_pegawai": idPegawai,
        "id_member": idMember,
        "bonus": bonus,
        "jumlah_deposit": jumlahDeposit,
        "total": total,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "member": member.toJson(),
        "pegawai": pegawai.toJson(),
    };
}