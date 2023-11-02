// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gofit/model/izinInstruktur.dart';

import 'globalApi.dart';

class IzinInstrukturApi {
  String baseUrl = GlobalApi.getBaseUrl();

  Future<List<IzinInstruktur>> getIzinInstruktur() async {
    Uri url = Uri.parse(baseUrl + 'absenInstruktur');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataIzin = responseData['data'] as List<dynamic>;

      List<IzinInstruktur> izins = dataIzin
          .map<IzinInstruktur>((izinData) => IzinInstruktur.fromJson(izinData))
          .toList();

      izins.forEach((element) {
        print(element);
      });

      return izins;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to ' + baseUrl);
    } else {
      throw Exception('Failed to get izin instruktur data');
    }
  }

  Future<List<IzinInstruktur>> getIzinByInstruktur() async {
    String userId = GlobalVariables.userId;
    Uri url = Uri.parse(baseUrl + 'absenByInstruktur/' + userId);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataIzin = responseData['data'] as List<dynamic>;

      List<IzinInstruktur> izinInstruktur = dataIzin
          .map<IzinInstruktur>((izinData) => IzinInstruktur.fromJson(izinData))
          .toList();

      izinInstruktur.forEach((element) {
        print(element);
      });

      return izinInstruktur;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to ' + baseUrl);
    } else {
      throw Exception('Failed to get data booking classes');
    }
  }

  Future<bool> addIzin(int idInstruktur, int idInstrukturPengganti, int idJadwalHarian, String statusInstruktur) async {
    Uri url = Uri.parse(baseUrl + 'absenInstruktur');

    final response = await http.post(url, body: {
      "id_instruktur" : idInstruktur.toString(),
      "id_instruktur_pengganti" : idInstrukturPengganti.toString(),
      "id_jadwal_harian": idJadwalHarian.toString(),
      "status_instruktur": statusInstruktur,
    });

    print(response.statusCode);
    if (response.statusCode == 200) {
      print("Data Added!");
      return true;
    } else {
      print("Failed Add Data!");
      return false;
    }
  }
}
