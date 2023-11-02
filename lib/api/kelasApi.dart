// ignore_for_file: file_names

import 'dart:convert';
import 'package:gofit/model/kelas.dart';
import 'package:http/http.dart' as http;

import 'globalApi.dart';

class KelasApi {
  String baseUrl = GlobalApi.getBaseUrl();

  Future<List<Kelas>> getKelas() async {
    Uri url = Uri.parse('${baseUrl}kelas');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataKelas = responseData['data'] as List<dynamic>;

      List<Kelas> kelas = dataKelas
          .map<Kelas>((kelasData) => Kelas.fromJson(kelasData))
          .toList();
      return kelas;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed to get izin instruktur data');
    }
  }
}
