// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/instrukturApi.dart';
import 'package:gofit/model/izinInstruktur.dart';
import 'package:gofit/api/izinInstrukturApi.dart';
import 'package:gofit/pages/add/addIzin.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class ShowIzinInstruktur extends StatefulWidget {
  const ShowIzinInstruktur({super.key});

  @override
  State<ShowIzinInstruktur> createState() => _ShowIzinInstrukturState();
}

class _ShowIzinInstrukturState extends State<ShowIzinInstruktur> {
  IzinInstrukturApi izinInstrukturApi = IzinInstrukturApi();
  late Future izinInstruktur;
  List<IzinInstruktur> listIzin = [];
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
    fetchDataInstruktur();
  }

  void fetchDataInstruktur() async {
    try {
      var dataInstruktur = await instrukturApi.getInstrukturById();

      setState(() {
        idInteger = dataInstruktur['id'];
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
              child: listIzin.isEmpty
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
                      itemCount: listIzin.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Material(
                            color: const Color.fromRGBO(0, 53, 102, .5),
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              title: Text("Nama Kelas: ${listIzin[index].jadwalHarian.kelas.namaKelas}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Pengganti : ${listIzin[index]
                                          .instrukturpengganti
                                          .namaInstruktur}"),
                                  Text("Konfirmasi : ${listIzin[index].confirm!}"),
                                ],
                              ),
                              trailing: Text("Tanggal : ${DateFormat('dd-MM-yyyy').format(
                                      listIzin[index].waktuPerizinan!)}"),
                              //detail izin
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<Widget>(
                                      builder: (BuildContext context) {
                                    return Scaffold(
                                      appBar: AppBar(
                                        title: const Text(
                                          "Detail Izin",
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
                                            'Instruktur yang mengajukan : ${listIzin[index]
                                                    .instruktur
                                                    .namaInstruktur}',
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
                                                  "Pengganti : ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  listIzin[index]
                                                      .instrukturpengganti
                                                      .namaInstruktur,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  "Kelas : ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  listIzin[index]
                                                      .jadwalHarian
                                                      .kelas
                                                      .namaKelas,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  "Tanggal pengajuan : ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  (DateFormat(
                                                          'dd-MM-yyyy HH:mm')
                                                      .format(listIzin[index]
                                                          .waktuPerizinan!)),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  "Tanggal jadwal harian : ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  (DateFormat('dd-MM-yyyy')
                                                      .format(listIzin[index]
                                                          .jadwalHarian
                                                          .tanggal)),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  "Keterangan : ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  listIzin[index]
                                                      .statusInstruktur,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  "Status Izin : ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  listIzin[index].confirm!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddIzinInstruktur()));
        },
        tooltip: "Tambah Izin",
        backgroundColor: const Color(0xFFFFC300),
        child: const Icon(Icons.note_add_sharp),
      ),
    );
  }
}
