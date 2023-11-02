// To parse this JSON data, do
//
//     final aktivasiMember = aktivasiMemberFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'member.dart';
import 'pegawai.dart';

List<AktivasiMember> aktivasiMemberFromJson(String str) => List<AktivasiMember>.from(json.decode(str).map((x) => AktivasiMember.fromJson(x)));

String aktivasiMemberToJson(List<AktivasiMember> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AktivasiMember {
    int id;
    String nomorTransaksi;
    String idPegawai;
    String idMember;
    DateTime waktuAktivasi;
    DateTime masaBerlaku;
    DateTime createdAt;
    DateTime updatedAt;
    Member member;
    Pegawai pegawai;

    AktivasiMember({
        required this.id,
        required this.nomorTransaksi,
        required this.idPegawai,
        required this.idMember,
        required this.waktuAktivasi,
        required this.masaBerlaku,
        required this.createdAt,
        required this.updatedAt,
        required this.member,
        required this.pegawai,
    });

    factory AktivasiMember.fromJson(Map<String, dynamic> json) => AktivasiMember(
        id: json["id"],
        nomorTransaksi: json["nomor_transaksi"],
        idPegawai: json["id_pegawai"],
        idMember: json["id_member"],
        waktuAktivasi: DateTime.parse(json["waktu_aktivasi"]),
        masaBerlaku: DateTime.parse(json["masa_berlaku"]),
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
        "waktu_aktivasi": waktuAktivasi.toIso8601String(),
        "masa_berlaku": masaBerlaku.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "member": member.toJson(),
        "pegawai": pegawai.toJson(),
    };
}