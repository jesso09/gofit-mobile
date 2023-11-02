
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/pages/add/addBooking.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../api/bookingClassApi.dart';
import '../../api/memberApi.dart';
import '../../model/bookingClass.dart';

class ShowBookingClass extends StatefulWidget {
  const ShowBookingClass({super.key});

  @override
  State<ShowBookingClass> createState() => _ShowBookingClassState();
}

class _ShowBookingClassState extends State<ShowBookingClass> {
  BookingClassApi bookingClassApi = BookingClassApi();
  late Future bookingClass;
  List<BookingClass> listBookingClass = [];
  bool isLoading = true;
  MemberApi memberApi = MemberApi();
  String idInteger = '';
  bool isWantToCancel = false;

  void refreshData() {
    bookingClass = bookingClassApi.getBookingClassByMember();
    bookingClass.then((value) {
      setState(() {
        listBookingClass = value;
      });
    });
    fetchDataMember();
  }

  @override
  void initState() {
    super.initState();
    bookingClass = bookingClassApi.getBookingClassByMember();
    bookingClass.then((value) {
      setState(() {
        listBookingClass = value;
        isLoading = false;
      });
    });
    fetchDataMember();
  }

  void fetchDataMember() async {
    try {
      var dataMember = await memberApi.getMemberById();

      setState(() {
        idInteger = dataMember['id'].toString();
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
              child: listBookingClass.isEmpty
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
                      itemCount: listBookingClass.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Material(
                            color: const Color.fromRGBO(0, 53, 102, .5),
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              title: Text(listBookingClass[index]
                                  .nomorBooking
                                  .toString()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(listBookingClass[index]
                                      .jadwalHarian
                                      .kelas
                                      .namaKelas),
                                  Text(
                                      "Tanggal Kelas : ${DateFormat('dd MMMM yyyy').format(listBookingClass[index].jadwalHarian.tanggal)}"),
                                ],
                              ),
                              trailing: IconButton(
                                color: Colors.red,
                                onPressed: () {
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
                                        descStyle: const TextStyle(fontSize: 14),
                                      ),
                                      title: "Cancellation",
                                      desc:
                                          "Are you sure you want to cancel this booking?",
                                      type: AlertType.warning,
                                      buttons: [
                                        DialogButton(
                                            radius: BorderRadius.circular(10),
                                            color: Colors.green,
                                            child: const Text(
                                              "Confirm",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);

                                              bookingClassApi
                                                  .cancelBooking(
                                                      listBookingClass[index]
                                                          .id!
                                                          .toString())
                                                  .then((value) {
                                                setState(() {
                                                  if (value) {
                                                    Alert(
                                                        context: context,
                                                        style: AlertStyle(
                                                          backgroundColor:
                                                              Colors.white,
                                                          isCloseButton: false,
                                                          alertBorder:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            side:
                                                                const BorderSide(
                                                              color: Color(
                                                                  0xff000814),
                                                              width: 4,
                                                            ),
                                                          ),
                                                          // descStyle: TextStyle(fontSize: 14),
                                                        ),
                                                        title: "Canceled!",
                                                        type: AlertType.success,
                                                        buttons: [
                                                          DialogButton(
                                                              radius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  Colors.green,
                                                              child: const Text(
                                                                "OK",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              }),
                                                        ]).show();
                                                  } else {
                                                    Alert(
                                                        context: context,
                                                        style: AlertStyle(
                                                          backgroundColor:
                                                              Colors.white,
                                                          isCloseButton: false,
                                                          alertBorder:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            side:
                                                                const BorderSide(
                                                              color: Color(
                                                                  0xff000814),
                                                              width: 4,
                                                            ),
                                                          ),
                                                          // descStyle: TextStyle(fontSize: 14),
                                                        ),
                                                        title:
                                                            "Max Cancellation H-1",
                                                        type: AlertType.error,
                                                        buttons: [
                                                          DialogButton(
                                                              radius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  Colors.green,
                                                              child: const Text(
                                                                "OK",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              }),
                                                        ]).show();
                                                  }
                                                });
                                              });
                                            }),
                                        DialogButton(
                                            radius: BorderRadius.circular(10),
                                            color: Colors.red,
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                      ]).show();
                                },
                                icon: const Icon(Icons.delete_forever),
                                tooltip: "Cancel Booking",
                              ),

                              //detail booking
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<Widget>(
                                      builder: (BuildContext context) {
                                    return Scaffold(
                                      appBar: AppBar(
                                        title: const Text(
                                          "Detail Booking",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor:
                                            const Color(0xff000814),
                                        leading: IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Colors
                                                .white,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      body: Center(
                                        child: Hero(
                                          tag: 'ListTile-Hero',
                                          child: Material(
                                            child: ListTile(
                                              title: Text(
                                                "Nomor Booking : ${listBookingClass[index].nomorBooking!}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'Data Detail Booking : ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Metode Pembayaran : ${listBookingClass[index].metodePembayaran}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    ("Tanggal Booking : ${DateFormat('dd MMMM yyyy').format(listBookingClass[index].waktuBooking!)}"),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'Data Jadwal yang Dibooking : ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Nama Kelas : ${listBookingClass[index].jadwalHarian.kelas.namaKelas}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Nama Instruktur : ${listBookingClass[index].jadwalHarian.instruktur.namaInstruktur}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Hari : ${listBookingClass[index].jadwalHarian.hari}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Tanggal Kelas : ${DateFormat('dd MMMM yyyy').format(listBookingClass[index].jadwalHarian.tanggal)}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Sesi : ${listBookingClass[index].jadwalHarian.sesi}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Waktu Kelas : ${DateFormat('HH:mm:ss').format(DateFormat('HH:mm:ss').parse(listBookingClass[index].jadwalHarian.waktuMulai.toString()))} - ${DateFormat('HH:mm:ss').format(DateFormat('HH:mm:ss').parse(listBookingClass[index].jadwalHarian.waktuSelesai.toString()))}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              tileColor: const Color.fromRGBO(0, 53, 102, .5),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
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
              MaterialPageRoute(builder: (context) => const AddBookingClass()));
        },
        tooltip: "Tambah Booking Kelas",
        backgroundColor: const Color(0xFFFFC300),
        child: const Icon(Icons.post_add_outlined),
      ),
    );
  }
}
