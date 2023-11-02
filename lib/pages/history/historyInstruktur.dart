// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/instrukturApi.dart';
import 'package:gofit/api/jadwalHarianApi.dart';
import 'package:gofit/model/izinInstruktur.dart';
import 'package:gofit/api/izinInstrukturApi.dart';
import 'package:gofit/model/jadwalHarian.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HistoryInstruktur extends StatefulWidget {
  const HistoryInstruktur({super.key});

  @override
  State<HistoryInstruktur> createState() => _HistoryInstrukturState();
}

class _HistoryInstrukturState extends State<HistoryInstruktur> {
  IzinInstrukturApi izinInstrukturApi = IzinInstrukturApi();
  JadwalHarianApi jadwalHarianApi = JadwalHarianApi();
  late Future izinInstruktur;
  late Future jadwalHarian;
  List<IzinInstruktur> listIzin = [];
  List<JadwalHarian> listJadwalHarian = [];
  bool isLoading = true;
  InstrukturApi instrukturApi = InstrukturApi();
  String idInteger = '';

  void refreshData() {
    izinInstruktur = izinInstrukturApi.getIzinByInstruktur();
    izinInstruktur.then((value) {
      setState(() {
        listIzin = value;
      });
    });
    //jadwal harian
    jadwalHarian = jadwalHarianApi.getJadwalByInstruktur();
    jadwalHarian.then((value) {
      setState(() {
        listJadwalHarian = value;
      });
    });
    fetchDataInstruktur();
  }

  @override
  void initState() {
    super.initState();
    izinInstruktur = izinInstrukturApi.getIzinByInstruktur();
    izinInstruktur.then((value) {
      setState(() {
        listIzin = value;
        isLoading = false;
      });
    });
    //jadwal harian
    jadwalHarian = jadwalHarianApi.getJadwalByInstruktur();
    jadwalHarian.then((value) {
      setState(() {
        listJadwalHarian = value;
      });
    });
    fetchDataInstruktur();
  }

  void fetchDataInstruktur() async {
    try {
      var dataInstruktur = await instrukturApi.getInstrukturById();

      setState(() {
        idInteger = dataInstruktur['id'].toString();
      });
      // print(idInteger.toString());
    } catch (error) {
      // ignore: avoid_print
      print('Gagal mengambil data anggota: $error');
    }
  }

  Future<void> refresh() async {
    final startTime = DateTime.now();
    refreshData();
    final endTime = DateTime.now();
    final executionTime = endTime.difference(startTime).inMilliseconds;

    if (executionTime < 1000) {
      await Future.delayed(Duration(milliseconds: 1000 - executionTime));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
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
          : LiquidPullToRefresh(
              onRefresh: refresh,
              color: const Color(0xff000814),
              // backgroundColor: const Color(0xFFFFC300),
              backgroundColor: Colors.white,
              height: 300,
              animSpeedFactor: 2,
              showChildOpacityTransition: true,
              child: listIzin.isEmpty && listJadwalHarian.isEmpty
                  ? SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Data Empty",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          const Text('\u{1F614}', style: TextStyle(fontSize: 30)),
                          ElevatedButton(
                            onPressed: refreshData,
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: listIzin.length + listJadwalHarian.length,
                      itemBuilder: (context, index) {
                        if (index < listIzin.length) {
                          return Card(
                            child: Material(
                              color: const Color.fromRGBO(255, 195, 0, .5),
                              borderRadius: BorderRadius.circular(10),
                              child: ListTile(
                                title: const Text("Izin Instruktur"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Keterangan : ${listIzin[index].statusInstruktur}"),
                                    Text("Pengganti : ${listIzin[index]
                                            .instrukturpengganti
                                            .namaInstruktur}"),
                                    Text("Konfirmasi : ${listIzin[index].confirm!}"),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    const Text("Tanggal Pengajuan"),
                                    Text((DateFormat('dd-MM-yyyy').format(
                                        listIzin[index].waktuPerizinan!))),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          final index2 = index - listIzin.length;
                          return Card(
                            child: Material(
                              color: const Color.fromRGBO(0, 53, 102, .5),
                              borderRadius: BorderRadius.circular(10),
                              child: ListTile(
                                title: const Text("Jadwal Harian"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Kelas : ${listJadwalHarian[index2]
                                            .kelas
                                            .namaKelas}"),
                                    Text("Hari : ${listJadwalHarian[index2].hari}"),
                                    Text("Status Kelas : ${listJadwalHarian[index2]
                                      .statusKelas}"),
                                  Text("${listJadwalHarian[index2].waktuMulai} - ${listJadwalHarian[index2].waktuSelesai}"),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    const Text("Tanggal Kelas : "),
                                    Text((DateFormat('dd-MM-yyyy').format(
                                        listJadwalHarian[index2].tanggal))),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }),
            ),
    );
  }
}
