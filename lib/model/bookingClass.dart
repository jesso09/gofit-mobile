// To parse this JSON data, do
//
//     final bookingClass = bookingClassFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'jadwalHarian.dart';
import 'member.dart';

List<BookingClass> bookingClassFromJson(String str) => List<BookingClass>.from(json.decode(str).map((x) => BookingClass.fromJson(x)));

String bookingClassToJson(List<BookingClass> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookingClass {
    int? id;
    String idJadwalHarian;
    String idMember;
    DateTime? waktuBooking;
    String? nomorBooking;
    String metodePembayaran;
    DateTime createdAt;
    DateTime updatedAt;
    Member member;
    JadwalHarian jadwalHarian;

    BookingClass({
        this.id,
        required this.idJadwalHarian,
        required this.idMember,
        this.waktuBooking,
        this.nomorBooking,
        required this.metodePembayaran,
        required this.createdAt,
        required this.updatedAt,
        required this.member,
        required this.jadwalHarian,
    });

    factory BookingClass.fromJson(Map<String, dynamic> json) => BookingClass(
        id: json["id"],
        idJadwalHarian: json["id_jadwal_harian"],
        idMember: json["id_member"],
        waktuBooking: json["waktu_booking"] == null ? null : DateTime.parse(json["waktu_booking"]),
        nomorBooking: json["nomor_booking"],
        metodePembayaran: json["metode_pembayaran"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        member: Member.fromJson(json["member"]),
        jadwalHarian: JadwalHarian.fromJson(json["jadwal_harian"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_jadwal_harian": idJadwalHarian,
        "id_member": idMember,
        "waktu_booking": waktuBooking?.toIso8601String(),
        "nomor_booking": nomorBooking,
        "metode_pembayaran": metodePembayaran,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "member": member.toJson(),
        "jadwal_harian": jadwalHarian.toJson(),
    };
}