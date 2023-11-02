// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/jadwalHarian.dart';
import 'globalApi.dart';

class JadwalHarianApi {
  String baseUrl = GlobalApi.getBaseUrl();

  Future<List<JadwalHarian>> getJadwalHarian() async {
    Uri url = Uri.parse('${baseUrl}jadwalHarian');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataJadwalHarian = responseData['data'] as List<dynamic>;

      List<JadwalHarian> jadwalHarian = dataJadwalHarian
          .map<JadwalHarian>((jadwalHarianData) => JadwalHarian.fromJson(jadwalHarianData))
          .toList();

      // jadwalHarian.forEach((element) {
      //   print(element);
      // });

      return jadwalHarian;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed to get izin instruktur data');
    }
  }

  Future<List<JadwalHarian>> getJadwalToday() async {
    Uri url = Uri.parse('${baseUrl}jadwalToday');
    
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataJadwalHarian = responseData['data'] as List<dynamic>;

      List<JadwalHarian> jadwalHarian = dataJadwalHarian
          .map<JadwalHarian>((jadwalHarianData) => JadwalHarian.fromJson(jadwalHarianData))
          .toList();

      // jadwalHarian.forEach((element) {
      //   print(element);
      // });

      return jadwalHarian;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed to get izin instruktur data');
    }
  }

  Future<List<JadwalHarian>> getJadwalByInstruktur() async {
    String userId = GlobalVariables.userId;
    // String userId = "1";
    Uri url = Uri.parse('${baseUrl}jadwalByInstruktur/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataJadwal = responseData['data'] as List<dynamic>;

      List<JadwalHarian> jadwalHarian = dataJadwal
          .map<JadwalHarian>((jadwalHarianData) => JadwalHarian.fromJson(jadwalHarianData))
          .toList();
      return jadwalHarian;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed to get data jadwals');
    }
  }

  Future presensiInstruktur(String idInstruktur, String idJadwalHarian, String status) async {
    Uri url = Uri.parse('${baseUrl}presensiInstruktur');

    final response = await http.post(url, body: {
      "id_instruktur": idInstruktur,
      "id_jadwal_harian": idJadwalHarian,
      "status": status,
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
