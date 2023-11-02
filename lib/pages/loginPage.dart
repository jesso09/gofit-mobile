// ignore_for_file: file_names

import 'dart:convert';
import 'package:gofit/pages/homepage/HomeMember.dart';
import 'package:gofit/pages/homepage/homeInstruktur.dart';
import 'package:gofit/pages/homepage/homeMo.dart';
import 'package:gofit/pages/show/showAllJadwalHarian.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../api/globalApi.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String baseUrl = GlobalApi.getBaseUrl();
  bool passwordVisible = true;
  late String role;

  Future doLogin(String? email, String? password) async {
    Uri url = Uri.parse('${baseUrl}login');

    final response = await http.post(url, body: {
      "email": email,
      "password": password,
    });

    var userLoggedIn = json.decode(response.body);
    if (response.statusCode == 200) {
      if (userLoggedIn['user'] == 'Instruktur') {
        role = 'Instruktur';
        GlobalVariables.userId = userLoggedIn['id'].toString();
      } else if (userLoggedIn['user'] == 'Member') {
        role = 'Member';
        GlobalVariables.userId = userLoggedIn['id'].toString();
      } else if (userLoggedIn['user'] == 'Pegawai') {
        if (userLoggedIn['role'] == 'MO') {
          role = 'MO';
          GlobalVariables.userId = userLoggedIn['id'].toString();
        } else {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color(0xff000814),
                Color(0xff001D3D),
                Color(0xff003566),
                // Color(0xffFFC300),
                // Color(0xffFFD60A),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    Text(
                      "GoFit",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 60,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 53, 102, 0.5),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: passwordVisible,
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        suffixIcon: IconButton(
                                          tooltip: passwordVisible
                                              ? "Show password"
                                              : "Hide password",
                                          onPressed: () {
                                            setState(() {
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          },
                                          icon: Icon(
                                            passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ShowAllJadwalHarian()));
                            },
                            icon: const Icon(
                              Icons.calendar_month,
                              color: Colors.black,
                            ),
                            label: const Text(
                              "Jadwal Harian",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              elevation: const MaterialStatePropertyAll(0),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xff000814),
                            ),
                            child: Center(
                              child: SizedBox(
                                height: 50,
                                width: 300,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xff003566),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    doLogin(emailController.text,
                                            passwordController.text)
                                        .then((value) {
                                      if (value) {
                                        Alert(
                                            context: context,
                                            style: AlertStyle(
                                              backgroundColor: Colors.white,
                                              isCloseButton: false,
                                              alertBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                side: const BorderSide(
                                                  color: Color(0xff003566),
                                                  width: 4,
                                                ),
                                              ),
                                              descStyle:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            title: "Login success",
                                            type: AlertType.success,
                                            buttons: [
                                              DialogButton(
                                                  radius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.green,
                                                  child: const Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    if (role == "Instruktur") {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const HomeInstruktur()),
                                                      );
                                                    } else if (role ==
                                                        "Member") {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const HomeMember()),
                                                      );
                                                    } else if (role == "MO") {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const HomeMo()));
                                                    }
                                                  }),
                                            ]).show();
                                      } else {
                                        Alert(
                                            context: context,
                                            style: AlertStyle(
                                              backgroundColor: Colors.white,
                                              isCloseButton: false,
                                              alertBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                side: const BorderSide(
                                                  color: Color(0xff003566),
                                                  width: 4,
                                                ),
                                              ),
                                              descStyle:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            title: "Login Failed",
                                            type: AlertType.error,
                                            buttons: [
                                              DialogButton(
                                                  radius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.green,
                                                  child: const Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  }),
                                            ]).show();
                                      }
                                    });
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) => ShowMember()));
                                  },
                                  child: const Text('Login'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
