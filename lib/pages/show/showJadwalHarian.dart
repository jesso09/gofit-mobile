// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/jadwalHarianApi.dart';
import 'package:gofit/model/jadwalHarian.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ShowJadwalHarian extends StatefulWidget {
  const ShowJadwalHarian({super.key});

  @override
  State<ShowJadwalHarian> createState() => _ShowJadwalHarianState();
}

class _ShowJadwalHarianState extends State<ShowJadwalHarian> {
  JadwalHarianApi jadwalHarianApi = JadwalHarianApi();
  late Future jadwalHarian;
  List<JadwalHarian> listJadwalHarian = [];
  bool isLoading = true;

  void refreshData() {
    jadwalHarian = jadwalHarianApi.getJadwalToday();
    jadwalHarian.then((value) {
      setState(() {
        listJadwalHarian = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    jadwalHarian = jadwalHarianApi.getJadwalToday();
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
                              leading: Icon(Icons.timer_rounded, 
                              color: listJadwalHarian[index].statusKelas == 'Kelas Dimulai'
                                        ? Colors.green.shade800
                                        : listJadwalHarian[index].statusKelas ==
                                                'Kelas Selesai'
                                            ? Colors.red.shade800
                                            : listJadwalHarian[index].statusKelas ==
                                                'Aktif'
                                                ?Colors.black
                                                : Colors.yellow,
                              ),
                              title:
                                  Text(listJadwalHarian[index].kelas.namaKelas),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(listJadwalHarian[index].hari),
                                  Text(listJadwalHarian[index]
                                      .instruktur
                                      .namaInstruktur),
                                  Text("${listJadwalHarian[index].waktuMulai} - ${listJadwalHarian[index].waktuSelesai}"),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'Kelas Mulai') {
                                    jadwalHarianApi.presensiInstruktur(
                                        listJadwalHarian[index]
                                            .instruktur
                                            .id
                                            .toString(),
                                        listJadwalHarian[index].id.toString(),
                                        value);
                                    refreshData();
                                    Alert(
                                        context: context,
                                        style: AlertStyle(
                                          backgroundColor: Colors.white,
                                          isCloseButton: false,
                                          alertBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            side: const BorderSide(
                                              color: Color(0xff003566),
                                              width: 4,
                                            ),
                                          ),
                                          descStyle: const TextStyle(fontSize: 14),
                                        ),
                                        title: "Started!",
                                        desc: "Kelas telah dimulai",
                                        type: AlertType.info,
                                        buttons: [
                                          DialogButton(
                                              radius: BorderRadius.circular(10),
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
                                  } else if (value == 'Kelas Selesai') {
                                    jadwalHarianApi.presensiInstruktur(
                                        listJadwalHarian[index]
                                            .instruktur
                                            .id
                                            .toString(),
                                        listJadwalHarian[index].id.toString(),
                                        value);
                                    refreshData();
                                    Alert(
                                        context: context,
                                        style: AlertStyle(
                                          backgroundColor: Colors.white,
                                          isCloseButton: false,
                                          alertBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            side: const BorderSide(
                                              color: Color(0xff003566),
                                              width: 4,
                                            ),
                                          ),
                                          descStyle: const TextStyle(fontSize: 14),
                                        ),
                                        title: "Ended!",
                                        desc: "Kelas telah selesai",
                                        type: AlertType.info,
                                        buttons: [
                                          DialogButton(
                                              radius: BorderRadius.circular(10),
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
                                },
                                itemBuilder: (BuildContext context) {
                                  if (listJadwalHarian[index].statusKelas == "Aktif") {
                                    return <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Kelas Mulai',
                                        child: ListTile(
                                          trailing: Icon(Icons.timer_outlined),
                                          iconColor: Colors.green,
                                          title: Text('Kelas Mulai'),
                                        ),
                                      ),
                                    ];
                                  } else if (listJadwalHarian[index].statusKelas == "Kelas Dimulai"){
                                    return <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Kelas Selesai',
                                        child: ListTile(
                                          title: Text('Kelas Selesai'),
                                          trailing:
                                              Icon(Icons.timer_off_outlined),
                                          iconColor: Colors.red,
                                        ),
                                      ),
                                    ];
                                  }else if(listJadwalHarian[index].statusKelas == "Kelas Selesai"){
                                    return <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Kelas Selesai',
                                        child: ListTile(
                                          title: Text('Kelas Telah Selesai'),
                                          trailing:
                                              Icon(Icons.cancel_schedule_send_sharp),
                                          iconColor: Colors.black,
                                        ),
                                      ),
                                    ];
                                  }else {
                                    return <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Kelas Libur',
                                        child: ListTile(
                                          title: Text('Kelas Libur'),
                                          trailing:
                                              Icon(Icons.cancel_schedule_send_sharp),
                                          iconColor: Colors.black,
                                        ),
                                      ),
                                    ];
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      }),
            ),
    );
  }
}
