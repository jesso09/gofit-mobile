// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gofit/api/bookingClassApi.dart';
import 'package:gofit/api/globalApi.dart';
import 'package:gofit/api/jadwalHarianApi.dart';
import 'package:gofit/api/memberApi.dart';
import 'package:gofit/model/bookingClass.dart';
import 'package:gofit/pages/homepage/homeMember.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../model/jadwalHarian.dart';

class AddBookingClass extends StatefulWidget {
  const AddBookingClass({super.key});

  @override
  State<AddBookingClass> createState() => _AddBookingClassState();
}

class _AddBookingClassState extends State<AddBookingClass> {
  int count = 0;
  BookingClassApi bookingClassApi = BookingClassApi();
  late Future bookingClass;
  List<BookingClass> listBookingClass = [];
  //ngambil data jadwal harian buat dipake di dropdown
  JadwalHarianApi jadwalHarianApi = JadwalHarianApi();
  late Future jadwalHarian;
  List<JadwalHarian> listJadwalHarian = [];
  //mengambil id member yang sedang login
  MemberApi memberApi = MemberApi();
  int? idInteger = 0;
  String idMember = '';
  String nama = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    jadwalHarian = jadwalHarianApi.getJadwalHarian();
    jadwalHarian.then((value) {
      setState(() {
        listJadwalHarian = value;
      });
    });
    fetchDataMember();
  }

  void fetchDataMember() async {
    try {
      var dataMember = await memberApi.getMemberById();

      setState(() {
        idInteger = dataMember['id'];
        idMember = dataMember['id_member'];
        nama = dataMember['nama'];
      });
      isLoading = false;
    } catch (error) {
      throw e;
    }
  }

  final TextEditingController metodePembayaranController =
      TextEditingController();
  int? selectedJadwal;
  String? selectedMetode;

  List<DropdownMenuItem<int>> get dropdownItems {
    List<DropdownMenuItem<int>> menuItems = [];

    for (int index = 0; index < listJadwalHarian.length; index++) {
      menuItems.add(
        DropdownMenuItem(
          value: listJadwalHarian[index].id,
          child: Text(listJadwalHarian[index].kelas.namaKelas),
        ),
      );
    }

    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropDownMetode {
    List<DropdownMenuItem<String>> itemMetode = [
      const DropdownMenuItem(value: "Paket", child: Text("Paket Kelas")),
      const DropdownMenuItem(value: "Cash", child: Text("Reguler")),
    ];
    return itemMetode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Tambah Booking Kelas",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff000814),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFFC300),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                      child: Column(
                    children: [
                      Theme(
                        data: ThemeData(
                            inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.3),
                          labelStyle: TextStyle(
                            color: Colors.black.withOpacity(1),
                          ),
                        )),
                        child: TextFormField(
                          enabled: false,
                          autocorrect: false,
                          autofocus: true,
                          readOnly: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: "$idMember - $nama"),
                          textInputAction: TextInputAction.next,
                        ),
                      ),

                      const SizedBox(height: 10),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Jadwal Harian"),
                        items: dropdownItems,
                        value: selectedJadwal,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedJadwal = newValue!;
                          });
                        },
                      ),

                      const SizedBox(height: 10),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Metode Pembayaran"),
                        items: dropDownMetode,
                        value: selectedMetode,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMetode = newValue!;
                          });
                        },
                      ),

                      //Save Button
                      const SizedBox(height: 50),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            bookingClassApi
                                .addBookingClass(selectedJadwal!.toInt(),
                                    idInteger!, selectedMetode!)
                                .then((value) {
                              setState(() {
                                if (value) {
                                  Alert(
                                      context: context,
                                      style: AlertStyle(
                                        backgroundColor: Colors.white,
                                        isCloseButton: false,
                                        alertBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          side: const BorderSide(
                                            color: Color(0xff000814),
                                            width: 4,
                                          ),
                                        ),
                                      ),
                                      title: "Data Added",
                                      type: AlertType.success,
                                      buttons: [
                                        DialogButton(
                                            radius: BorderRadius.circular(10),
                                            color: Colors.green,
                                            child: const Text("OK"),
                                            onPressed: () {
                                              GlobalVariables.indexPageMember =
                                                  2;
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomeMember()),
                                                  (Route<dynamic> route) =>
                                                      false);
                                            }),
                                      ]).show();
                                } else {
                                  Alert(
                                      context: context,
                                      style: AlertStyle(
                                        backgroundColor: Colors.white,
                                        isCloseButton: false,
                                        alertBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          side: const BorderSide(
                                            color: Color(0xff000814),
                                            width: 4,
                                          ),
                                        ),
                                      ),
                                      title: "Failed Adding Data",
                                      type: AlertType.error,
                                      buttons: [
                                        DialogButton(
                                            radius: BorderRadius.circular(10),
                                            color: Colors.green,
                                            child: const Text("OK"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                      ]).show();
                                }
                              });
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFFFC300)),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
              ));
  }
}
