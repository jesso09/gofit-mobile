// To parse this JSON data, do
//
//     final pegawai = pegawaiFromJson(jsonString);

import 'dart:convert';

List<Pegawai> pegawaiFromJson(String str) => List<Pegawai>.from(json.decode(str).map((x) => Pegawai.fromJson(x)));

String pegawaiToJson(List<Pegawai> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pegawai {
    int id;
    String idPegawai;
    String idRole;
    String namaPegawai;
    String alamat;
    DateTime tglLahir;
    String gender;
    String noTelp;
    String email;
    String password;
    DateTime? createdAt;
    DateTime? updatedAt;
    Role role;

    Pegawai({
        required this.id,
        required this.idPegawai,
        required this.idRole,
        required this.namaPegawai,
        required this.alamat,
        required this.tglLahir,
        required this.gender,
        required this.noTelp,
        required this.email,
        required this.password,
        this.createdAt,
        this.updatedAt,
        required this.role,
    });

    factory Pegawai.fromJson(Map<String, dynamic> json) => Pegawai(
        id: json["id"],
        idPegawai: json["id_pegawai"],
        idRole: json["id_role"],
        namaPegawai: json["nama_pegawai"],
        alamat: json["alamat"],
        tglLahir: DateTime.parse(json["tgl_lahir"]),
        gender: json["gender"],
        noTelp: json["no_telp"],
        email: json["email"],
        password: json["password"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        role: Role.fromJson(json["role"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_pegawai": idPegawai,
        "id_role": idRole,
        "nama_pegawai": namaPegawai,
        "alamat": alamat,
        "tgl_lahir": "${tglLahir.year.toString().padLeft(4, '0')}-${tglLahir.month.toString().padLeft(2, '0')}-${tglLahir.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "no_telp": noTelp,
        "email": email,
        "password": password,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "role": role.toJson(),
    };
}

class Role {
    int id;
    String namaRole;
    DateTime createdAt;
    DateTime updatedAt;

    Role({
        required this.id,
        required this.namaRole,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        namaRole: json["nama_role"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama_role": namaRole,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
