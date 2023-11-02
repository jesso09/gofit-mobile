// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/jadwalHarianApi.dart';
import 'package:gofit/model/jadwalHarian.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class ShowAllJadwalHarian extends StatefulWidget {
  const ShowAllJadwalHarian({super.key});

  @override
  State<ShowAllJadwalHarian> createState() => _ShowAllJadwalHarianState();
}

class _ShowAllJadwalHarianState extends State<ShowAllJadwalHarian> {
  JadwalHarianApi jadwalHarianApi = JadwalHarianApi();
  late Future jadwalHarian;
  List<JadwalHarian> listJadwalHarian = [];
  bool isLoading = true;

  void refreshData() {
    jadwalHarian = jadwalHarianApi.getJadwalHarian();
    jadwalHarian.then((value) {
      setState(() {
        listJadwalHarian = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    jadwalHarian = jadwalHarianApi.getJadwalHarian();
    jadwalHarian.then((value) {
      setState(() {
        listJadwalHarian = value;
        isLoading = false;
      });
    });
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
            "Jadwal Harian",
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
                                  Text(
  listJadwalHarian[index].kelas.classDetail.harga
),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Text("Tanggal : ${DateFormat('dd-MM-yyyy').format(
                                          listJadwalHarian[index].tanggal)}"),
                                  Text("Instruktur : ${listJadwalHarian[index]
                                          .instruktur
                                          .namaInstruktur}")
                                ],
                              ),
                              
                            ),
                          ),
                        );
                      }),
            ),
    );
  }
}
