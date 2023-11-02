// ignore_for_file: file_names

import 'dart:convert';
import 'package:gofit/model/instruktur.dart';
import 'package:http/http.dart' as http;
import 'globalApi.dart';

class InstrukturApi {
  String baseUrl = GlobalApi.getBaseUrl();

  Future<List<Instruktur>> getInstruktur() async {
    Uri url = Uri.parse('${baseUrl}instruktur');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataInstruktur = responseData['data'] as List<dynamic>;

      List<Instruktur> instrukturs = dataInstruktur
          .map<Instruktur>((instrukturData) => Instruktur.fromJson(instrukturData))
          .toList();
    // instrukturs.forEach((element) {
    //   print(dataInstruktur);
    // });
      return instrukturs;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get data instruktur');
    }
  }

  Future<dynamic> getInstrukturById() async {
    String userId = GlobalVariables.userId;
    Uri url = Uri.parse('${baseUrl}instruktur/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      var dataInstruktur = responseData['data'];
      return dataInstruktur;
    } else {
      throw Exception('Failed to get Instruktur data');
    }
  }
}