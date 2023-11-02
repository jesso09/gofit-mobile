// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/member.dart';
import 'globalApi.dart';

class MemberApi {

  String baseUrl = GlobalApi.getBaseUrl();

  Future<List<Member>> getMember() async {
    Uri url = Uri.parse('${baseUrl}member');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataMember = responseData['data'] as List<dynamic>;

      List<Member> members = dataMember
          .map<Member>((memberData) => Member.fromJson(memberData))
          .toList();
    // members.forEach((element) {
    //   print(dataMember);
    // });
      return members;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get data member');
    }
  }

  Future addMember(String? nama, String? alamat, String tglLahir,
      String? noTelp, String? gender, String? email) async {
    Uri url = Uri.parse('${baseUrl}member');

    // String formattedDate = DateFormat('yyyy-MM-dd').format(tglLahir);
    final response = await http.post(url, body: {
      "nama": nama,
      "alamat": alamat,
      "tgl_lahir": tglLahir,
      "no_telp": noTelp,
      "gender": gender,
      "email": email,
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> getMemberById() async {
    String userId = GlobalVariables.userId;
    Uri url = Uri.parse('${baseUrl}member/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      var dataMember = responseData['data']; // Set nilai dataMember setelah mendapatkan respons
      return dataMember;
    } else {
      throw Exception('Failed to get member data');
    }
  }

  
}
