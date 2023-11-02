// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/globalApi.dart';
import 'package:gofit/api/instrukturApi.dart';
import 'package:gofit/api/izinInstrukturApi.dart';
import 'package:gofit/api/jadwalHarianApi.dart';
import 'package:gofit/model/instruktur.dart';
import 'package:gofit/pages/homepage/homeInstruktur.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../model/jadwalHarian.dart';

class AddIzinInstruktur extends StatefulWidget {
  const AddIzinInstruktur({super.key});

  @override
  State<AddIzinInstruktur> createState() => _AddIzinInstrukturState();
}

class _AddIzinInstrukturState extends State<AddIzinInstruktur> {
  final TextEditingController statusInstrukturController =
      TextEditingController();
  int count = 0;
  IzinInstrukturApi izinInstrukturApi = IzinInstrukturApi();
  //ngambil data jadwal harian buat dipake di dropdown
  JadwalHarianApi jadwalHarianApi = JadwalHarianApi();
  late Future jadwalHarian;
  late Future instruktur;
  List<JadwalHarian> listJadwalHarian = [];
  List<Instruktur> listInstruktur = [];
  //mengambil id instruktur yang sedang login
  InstrukturApi instrukturApi = InstrukturApi();
  int? idInteger = 0;
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
    instruktur = instrukturApi.getInstruktur();
    instruktur.then((value) {
      setState(() {
        listInstruktur = value;
      });
    });
    fetchDataInstruktur();
  }

  void fetchDataInstruktur() async {
    try {
      var dataInstruktur = await instrukturApi.getInstrukturById();

      setState(() {
        idInteger = dataInstruktur['id'];
        nama = dataInstruktur['nama_instruktur'];
        isLoading = false;
      });
      // print(idInteger.toString());
    } catch (error) {
      // ignore: avoid_print
      print('Gagal mengambil data anggota: $error');
    }
  }

  final TextEditingController metodePembayaranController =
      TextEditingController();
  int? selectedJadwal;
  int? selectedPengganti;

  List<DropdownMenuItem<int>> get dropDownInstruktur {
    List<DropdownMenuItem<int>> menuItems = [];

    for (int index = 0; index < listInstruktur.length; index++) {
      menuItems.add(
        DropdownMenuItem(
          value: listInstruktur[index].id,
          child: Text(listInstruktur[index].namaInstruktur),
        ),
      );
    }

    return menuItems;
  }

  List<DropdownMenuItem<int>> get dropDownJadwalHarian {
    List<DropdownMenuItem<int>> itemJadwal = [];

    for (int index = 0; index < listJadwalHarian.length; index++) {
      itemJadwal.add(
        DropdownMenuItem(
          value: listJadwalHarian[index].id,
          child: Text(listJadwalHarian[index].kelas.namaKelas),
        ),
      );
    }

    return itemJadwal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Pengajuan Izin",
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
                              labelText: "Nama : $nama"),
                          textInputAction: TextInputAction.next,
                        ),
                      ),

                      const SizedBox(height: 10),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Instruktur Pengganti"),
                        items: dropDownInstruktur,
                        value: selectedPengganti,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedPengganti = newValue!;
                          });
                        },
                      ),

                      const SizedBox(height: 10),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Jadwal Harian"),
                        items: dropDownJadwalHarian,
                        value: selectedJadwal,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedJadwal = newValue!;
                          });
                        },
                      ),

                      const SizedBox(height: 10),
                      TextFormField(
                        autocorrect: false,
                        autofocus: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Keterangan Izin"),
                        // textInputAction: TextInputAction.next,
                        controller: statusInstrukturController,
                      ),

                      //Save Button
                      const SizedBox(height: 50),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            izinInstrukturApi
                                .addIzin(
                                    idInteger!,
                                    selectedPengganti!.toInt(),
                                    selectedJadwal!.toInt(),
                                    statusInstrukturController.text)
                                .then((value) {
                              setState(() {
                                if (value) {
                                  Alert(
                                      context: context,
                                      title: "Data Added",
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
                                      type: AlertType.success,
                                      buttons: [
                                        DialogButton(
                                            radius: BorderRadius.circular(10),
                                            color: Colors.green,
                                            child: const Text("OK"),
                                            onPressed: () {
                                              GlobalVariables
                                                  .indexPageInstruktur = 2;
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomeInstruktur()),
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
