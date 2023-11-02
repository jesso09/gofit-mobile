// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/jadwalHarianApi.dart';
import 'package:gofit/model/jadwalHarian.dart';
import 'package:gofit/pages/show/showMember.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../api/instrukturApi.dart';

class ShowKelasInstruktur extends StatefulWidget {
  const ShowKelasInstruktur({super.key});

  @override
  State<ShowKelasInstruktur> createState() => _ShowKelasInstrukturState();
}

class _ShowKelasInstrukturState extends State<ShowKelasInstruktur> {
  JadwalHarianApi jadwalHarianApi = JadwalHarianApi();
  late Future jadwalHarian;
  List<JadwalHarian> listJadwalHarian = [];
  bool isLoading = true;
  InstrukturApi instrukturApi = InstrukturApi();
  String idInteger = '';

  void refreshData() {
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
    jadwalHarian = jadwalHarianApi.getJadwalByInstruktur();
    jadwalHarian.then((value) {
      setState(() {
        listJadwalHarian = value;
        isLoading = false;
      });
    });
    fetchDataInstruktur();
  }

  void fetchDataInstruktur() async {
    try {
      var dataInstruktur = await instrukturApi.getInstrukturById();

      setState(() {
        idInteger = dataInstruktur['id'];
      });
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFFC300),
              ),
            )
          : LiquidPullToRefresh(
              onRefresh: refresh,
              color: const Color(0xff000814),
              backgroundColor: Colors.white,
              height: 300,
              animSpeedFactor: 2,
              showChildOpacityTransition: true,
              child: listJadwalHarian.isEmpty
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
                          const Text('\u{1F614}',
                              style: TextStyle(fontSize: 30)),
                          ElevatedButton(
                            onPressed: refreshData,
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: listJadwalHarian.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Material(
                            color: const Color.fromRGBO(0, 53, 102, .5),
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              title:
                                  Text(listJadwalHarian[index].kelas.namaKelas),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(listJadwalHarian[index].hari),
                                  Text(listJadwalHarian[index]
                                      .instruktur
                                      .namaInstruktur),
                                ],
                              ),
                              trailing: Text("Tanggal : ${DateFormat('dd-MM-yyyy').format(
                                      listJadwalHarian[index].tanggal)}"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ShowMember(
                                        idJadwalHarian:
                                            listJadwalHarian[index].id);
                                  }),
                                );
                              },
                            ),
                          ),
                        );
                      }),
            ),
    );
  }
}
