// ignore_for_file: file_names

import 'dart:convert';
import 'package:gofit/model/aktivasiMember.dart';
import 'package:gofit/model/depositCash.dart';
import 'package:gofit/model/depositKelas.dart';
import 'package:http/http.dart' as http;
import 'globalApi.dart';

class DepositApi {
  String baseUrl = GlobalApi.getBaseUrl();

  Future<List<DepositCash>> getDepositCashByMember() async {
    String userId = GlobalVariables.userId;
    Uri url = Uri.parse('${baseUrl}depositCashByMember/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataDeposit = responseData['data'] as List<dynamic>;

      List<DepositCash> depositCash = dataDeposit
          .map<DepositCash>(
              (depositCashData) => DepositCash.fromJson(depositCashData))
          .toList();

      return depositCash;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed to get data booking classes');
    }
  }
  
  //deposit classes
  Future<List<DepositKelas>> getDepositClassByMember() async {
    String userId = GlobalVariables.userId;
    Uri url = Uri.parse('${baseUrl}depositClassByMember/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataDepKelas = responseData['data'] as List<dynamic>;

      List<DepositKelas> depositClass = dataDepKelas
          .map<DepositKelas>(
              (depositClassData) => DepositKelas.fromJson(depositClassData))
          .toList();
      return depositClass;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed to get data booking classes');
    }
  }

  // aktivasi member
  Future<List<AktivasiMember>> getAktivasiByMember() async {
    String userId = GlobalVariables.userId;
    Uri url = Uri.parse('${baseUrl}aktivasiByMember/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataAktivasi = responseData['data'] as List<dynamic>;

      List<AktivasiMember> aktivasiMember = dataAktivasi
          .map<AktivasiMember>(
              (aktivasiMemberData) => AktivasiMember.fromJson(aktivasiMemberData))
          .toList();
      return aktivasiMember;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed to get data booking classes');
    }
  }
}