// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/bookingClassApi.dart';
import 'package:gofit/api/instrukturApi.dart';
import 'package:gofit/model/bookingClass.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ShowMember extends StatefulWidget {
  final int idJadwalHarian;

  const ShowMember({required this.idJadwalHarian, Key? key}) : super(key: key);

  @override
  State<ShowMember> createState() => _ShowMemberState();
}

class _ShowMemberState extends State<ShowMember> {
  BookingClassApi bookingClassApi = BookingClassApi();
  InstrukturApi instrukturApi = InstrukturApi();
  late Future member;
  List<BookingClass> listMember = [];
  bool isLoading = true;
  bool isMemberHadir = false;
  String idInteger = "";

  void refreshData() {
    member = bookingClassApi.getBookingByJadwal(widget.idJadwalHarian);
    member.then((value) {
      setState(() {
        listMember = value;
      });
    });
    fetchDataInstruktur();
  }

  @override
  void initState() {
    super.initState();
    member = bookingClassApi.getBookingByJadwal(widget.idJadwalHarian);
    member.then((value) {
      setState(() {
        listMember = value;
        isLoading = false;
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
          "Presensi Member",
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
              child: listMember.isEmpty
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
                      itemCount: listMember.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Material(
                            color: const Color.fromRGBO(0, 53, 102, .5),
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              leading: Icon(
                                Icons.person_pin_rounded,
                                color:
                                    listMember[index].member.presensi == 'Hadir'
                                        ? Colors.green.shade800
                                        : listMember[index].member.presensi ==
                                                'Tidak Hadir'
                                            ? Colors.red.shade800
                                            : Colors.black,
                              ),
                              title: Text(listMember[index].member.idMember),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(listMember[index].member.nama),
                                  Text("Masa Berlaku : ${listMember[index].member.masaBerlaku !=
                                              null
                                          ? DateFormat('dd-MM-yyyy').format(
                                              listMember[index]
                                                  .member
                                                  .masaBerlaku!)
                                          : "Belum Aktivasi"}"),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'Hadir') {
                                    bookingClassApi.presensiMember(
                                        idInteger,
                                        listMember[index].member.id.toString(),
                                        listMember[index].id.toString(),
                                        value);
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
                                        title: "Member Hadir!",
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
                                                refreshData();
                                                Navigator.pop(context);
                                              }),
                                        ]).show();
                                  } else if (value == 'Tidak Hadir') {
                                    bookingClassApi.presensiMember(
                                        idInteger,
                                        listMember[index].member.id.toString(),
                                        listMember[index].id.toString(),
                                        value);
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
                                        title: "Member Tidak Hadir!",
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
                                                refreshData();
                                                Navigator.pop(context);
                                              }),
                                        ]).show();
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  if (listMember[index].member.presensi ==
                                      null) {
                                    return <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Hadir',
                                        child: ListTile(
                                          trailing: Icon(Icons.check_circle),
                                          iconColor: Colors.green,
                                          title: Text('Hadir'),
                                        ),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'Tidak Hadir',
                                        child: ListTile(
                                          trailing: Icon(Icons.cancel),
                                          iconColor: Colors.red,
                                          title: Text('Tidak Hadir'),
                                        ),
                                      ),
                                    ];
                                  } else {
                                    return <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        child: ListTile(
                                          title: Text('Member sudah presensi!'),
                                          trailing: Icon(Icons.check_circle),
                                          iconColor: Colors.green,
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
