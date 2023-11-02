// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/jadwalHarianApi.dart';
import 'package:gofit/model/jadwalHarian.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class ShowJadwalUmum extends StatefulWidget {
  const ShowJadwalUmum({super.key});

  @override
  State<ShowJadwalUmum> createState() => _ShowJadwalUmumState();
}

class _ShowJadwalUmumState extends State<ShowJadwalUmum> {
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
      // backgroundColor: Color(0xff000814),
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
                                  MaterialPageRoute<Widget>(
                                      builder: (BuildContext context) {
                                    return Scaffold(
                                      appBar: AppBar(
                                        title: const Text(
                                          "Detail Jadwal",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor:
                                            const Color(0xff000814),
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
                                      body: Center(
                                        child: ListTile(
                                          title: Text(
                                            'Nama Kelas : ${listJadwalHarian[index]
                                                    .kelas
                                                    .namaKelas}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          subtitle: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  "Instruktur : ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  listJadwalHarian[index]
                                                      .instruktur
                                                      .namaInstruktur,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  "Hari : ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  listJadwalHarian[index].hari,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  "Tanggal Kelas : ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  (DateFormat('dd-MM-yyyy')
                                                      .format(listJadwalHarian[
                                                              index]
                                                          .tanggal)),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  "Status Kelas : ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  listJadwalHarian[index]
                                                      .statusKelas
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  "Waktu Kelas : ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text("${listJadwalHarian[index]
                                                        .waktuMulai} - ${listJadwalHarian[index]
                                                        .waktuSelesai}"),
                                              ]),
                                          tileColor: const Color.fromRGBO(
                                              0, 53, 102, .5),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    );
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
