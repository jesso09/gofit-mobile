// To parse this JSON data, do
//
//     final member = memberFromJson(jsonString);

import 'dart:convert';

List<Member> memberFromJson(String str) => List<Member>.from(json.decode(str).map((x) => Member.fromJson(x)));

String memberToJson(List<Member> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Member {
    int id;
    String idMember;
    String nama;
    String alamat;
    DateTime tglLahir;
    String noTelp;
    String gender;
    String email;
    String password;
    DateTime? masaBerlaku;
    String status;
    String depositCash;
    String depositKelas;
    String? presensi;
    DateTime createdAt;
    DateTime updatedAt;

    Member({
        required this.id,
        required this.idMember,
        required this.nama,
        required this.alamat,
        required this.tglLahir,
        required this.noTelp,
        required this.gender,
        required this.email,
        required this.password,
        this.masaBerlaku,
        required this.status,
        required this.depositCash,
        required this.depositKelas,
        this.presensi,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        idMember: json["id_member"],
        nama: json["nama"],
        alamat: json["alamat"],
        tglLahir: DateTime.parse(json["tgl_lahir"]),
        noTelp: json["no_telp"],
        gender: json["gender"],
        email: json["email"],
        password: json["password"],
        masaBerlaku: json["masa_berlaku"] == null ? null : DateTime.parse(json["masa_berlaku"]),
        status: json["status"],
        depositCash: json["deposit_cash"],
        depositKelas: json["deposit_kelas"],
        presensi: json["presensi"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_member": idMember,
        "nama": nama,
        "alamat": alamat,
        "tgl_lahir": "${tglLahir.year.toString().padLeft(4, '0')}-${tglLahir.month.toString().padLeft(2, '0')}-${tglLahir.day.toString().padLeft(2, '0')}",
        "no_telp": noTelp,
        "gender": gender,
        "email": email,
        "password": password,
        "masa_berlaku": "${masaBerlaku!.year.toString().padLeft(4, '0')}-${masaBerlaku!.month.toString().padLeft(2, '0')}-${masaBerlaku!.day.toString().padLeft(2, '0')}",
        "status": status,
        "deposit_cash": depositCash,
        "deposit_kelas": depositKelas,
        "presensi": presensi,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}