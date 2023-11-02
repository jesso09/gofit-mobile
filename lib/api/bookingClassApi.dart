// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/bookingClass.dart';
import 'globalApi.dart';

class BookingClassApi {
  String baseUrl = GlobalApi.getBaseUrl();

  Future<List<BookingClass>> getBookingClass() async {
    Uri url = Uri.parse(baseUrl + 'bookingClass');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataBookingClass = responseData['data'] as List<dynamic>;

      List<BookingClass> bookingClass = dataBookingClass
          .map<BookingClass>(
              (bookingClassData) => BookingClass.fromJson(bookingClassData))
          .toList();

      bookingClass.forEach((element) {
        print(element);
      });

      return bookingClass;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to ' + baseUrl);
    } else {
      throw Exception('Failed to get data booking classes');
    }
  }

  Future<bool> addBookingClass(
      int idJadwalHarian, int idMember, String metodePembayaran) async {
    Uri url = Uri.parse(baseUrl + 'bookingClass');

    final response = await http.post(url, body: {
      "id_jadwal_harian": idJadwalHarian.toString(),
      "id_member": idMember.toString(),
      "metode_pembayaran": metodePembayaran,
    });

    if (response.statusCode == 200) {
      print("Data Added!");
      return true;
    } else {
      print("Failed Add Data!");
      return false;
    }
  }

  Future<List<BookingClass>> getBookingClassByMember() async {
    String userId = GlobalVariables.userId;
    Uri url = Uri.parse(baseUrl + 'bookingClassByMember/' + userId);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataBookingClass = responseData['data'] as List<dynamic>;

      List<BookingClass> bookingClass = dataBookingClass
          .map<BookingClass>(
              (bookingClassData) => BookingClass.fromJson(bookingClassData))
          .toList();

      bookingClass.forEach((element) {
        print(element);
      });

      return bookingClass;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to ' + baseUrl);
    } else {
      throw Exception('Failed to get data booking classes');
    }
  }

  Future<bool> cancelBooking(String id) async {
    final url = Uri.parse(baseUrl + 'bookingClass/' + id);

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Successfully canceled booking');
      return true;
    } else {
      print('Failed to cancel booking');
      return false;
    }
  }

  Future<List<BookingClass>> getBookingByJadwal(int idJadwalHarian) async {
    // String userId = GlobalVariables.userId;
    // idJadwalHarian = 1;
    String userId = idJadwalHarian.toString();
    
    Uri url = Uri.parse(baseUrl + 'bookingbyJadwal/' + userId);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataBookingClass = responseData['data'] as List<dynamic>;

      List<BookingClass> bookingClass = dataBookingClass
          .map<BookingClass>(
              (bookingClassData) => BookingClass.fromJson(bookingClassData))
          .toList();

      bookingClass.forEach((element) {
        print(element);
      });

      return bookingClass;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to ' + baseUrl);
    } else {
      throw Exception('Failed to get data booking classes');
    }
  }

  Future presensiMember(String idInstruktur, String idMember, String idBookingClass, String status) async {
    Uri url = Uri.parse(baseUrl+'absenMemberKelas');

    final response = await http.post(url, body: {
      "id_instruktur": idInstruktur,
      "id_member": idMember,
      "id_booking_kelas": idBookingClass,
      "status": status,
    });
    print(response.body);
    if (response.statusCode == 200) {
      print("Data Added!");
      return true;
    } else {
      print("Falied Add Data!");
      return false;
    }
  }
}
