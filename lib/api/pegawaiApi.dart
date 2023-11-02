// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/pegawai.dart';
import 'globalApi.dart';

class PegawaiApi {
  String baseUrl = GlobalApi.getBaseUrl();

  Future<List<Pegawai>> getPegawai() async {
    Uri url = Uri.parse('${baseUrl}pegawai');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataPegawai = responseData['data'] as List<dynamic>;

      List<Pegawai> pegawais = dataPegawai
          .map<Pegawai>((pegawaiData) => Pegawai.fromJson(pegawaiData))
          .toList();
      return pegawais;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get data instruktur');
    }
  }

  Future<dynamic> getPegawaiById() async {
    //for test purposes
    String userId = '1';
    // String userId = GlobalVariables.userId;
    Uri url = Uri.parse('${baseUrl}pegawai/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      var dataPegawai = responseData['data'];
      return dataPegawai;
    } else {
      throw Exception('Failed to get Instruktur data');
    }
  }
}