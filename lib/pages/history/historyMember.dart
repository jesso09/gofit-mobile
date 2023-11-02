// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/bookingClassApi.dart';
import 'package:gofit/api/depositApi.dart';
import 'package:gofit/api/memberApi.dart';
import 'package:gofit/model/aktivasiMember.dart';
import 'package:gofit/model/bookingClass.dart';
import 'package:gofit/model/depositCash.dart';
import 'package:gofit/model/depositKelas.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HistoryMember extends StatefulWidget {
  const HistoryMember({super.key});

  @override
  State<HistoryMember> createState() => _HistoryMemberState();
}

class _HistoryMemberState extends State<HistoryMember> {
  DepositApi depositApi = DepositApi();
  BookingClassApi bookingClassApi = BookingClassApi();
  late Future aktivasiMember;
  late Future depositCash;
  late Future depositClass;
  late Future bookingClass;
  List<AktivasiMember> listAktivasi = [];
  List<DepositCash> listDepoCash = [];
  List<DepositKelas> listDepoKelas = [];
  List<BookingClass> listBookingClass = [];
  bool isLoading = true;
  MemberApi instrukturApi = MemberApi();
  String idInteger = '';

  void refreshData() {
    // aktivasi member
    aktivasiMember = depositApi.getAktivasiByMember();
    aktivasiMember.then((value) {
      setState(() {
        listAktivasi = value;
      });
    });

    //deposit cash
    depositCash = depositApi.getDepositCashByMember();
    depositCash.then((value) {
      setState(() {
        listDepoCash = value;
      });
    });

    //deposit kelas
    depositClass = depositApi.getDepositClassByMember();
    depositClass.then((value) {
      setState(() {
        listDepoKelas = value;
      });
    });

    //booking kelas
    bookingClass = bookingClassApi.getBookingClassByMember();
    bookingClass.then((value) {
      setState(() {
        listBookingClass = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // aktivasi member
    aktivasiMember = depositApi.getAktivasiByMember();
    aktivasiMember.then((value) {
      setState(() {
        listAktivasi = value;
        isLoading = false;
      });
    });

    //deposit cash
    depositCash = depositApi.getDepositCashByMember();
    depositCash.then((value) {
      setState(() {
        listDepoCash = value;
        isLoading = false;
      });
    });

    //deposit kelas
    depositClass = depositApi.getDepositClassByMember();
    depositClass.then((value) {
      setState(() {
        listDepoKelas = value;
        isLoading = false;
      });
    });

    //booking kelas
    bookingClass = bookingClassApi.getBookingClassByMember();
    bookingClass.then((value) {
      setState(() {
        listBookingClass = value;
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
              child: listAktivasi.isEmpty &&
                      listDepoCash.isEmpty &&
                      listDepoKelas.isEmpty &&
                      listBookingClass.isEmpty
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
                      itemCount: listAktivasi.length +
                          listDepoCash.length +
                          listDepoKelas.length +
                          listBookingClass.length,
                      itemBuilder: (context, index) {
                        if (index < listAktivasi.length) {
                          //list aktivasi member
                          return Card(
                            child: Material(
                              color: const Color.fromRGBO(255, 195, 0, .5),
                              borderRadius: BorderRadius.circular(10),
                              child: ListTile(
                                title: const Text("Aktivasi"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Pegawai : ${listAktivasi[index].pegawai.idPegawai} - ${listAktivasi[index].pegawai.namaPegawai}"),
                                    Text(
                                        "Nomor Transaksi : ${listAktivasi[index].nomorTransaksi}"),
                                    Text(
                                        "Masa Berlaku : ${DateFormat('dd-MM-yyyy').format(listAktivasi[index].masaBerlaku)}"),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    const Text("Tanggal Aktivasi"),
                                    Text((DateFormat('dd-MM-yyyy').format(
                                        listAktivasi[index].waktuAktivasi))),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (index <
                            listAktivasi.length + listDepoCash.length) {
                          //list deposit cash
                          final index2 = index - listAktivasi.length;
                          return Card(
                            child: Material(
                              color: const Color.fromARGB(126, 47, 143, 232),
                              borderRadius: BorderRadius.circular(10),
                              child: ListTile(
                                title: const Text("Deposit Cash"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Pegawai : ${listDepoCash[index2].pegawai.idPegawai} - ${listDepoCash[index2].pegawai.namaPegawai}"),
                                    Text(
                                        "No Transaksi : ${listDepoCash[index2].nomorTransaksi}"),
                                    Text(
                                        "Bonus : Rp. ${NumberFormat.decimalPattern('id_ID').format(int.parse(listDepoCash[index2].bonus))}"),
                                    Text(
                                      "Jumlah Top Up : Rp. ${NumberFormat.decimalPattern('id_ID').format(int.parse(listDepoCash[index2].jumlahDeposit))}",
                                    ),
                                    Text(
                                      "Total : Rp. ${NumberFormat.decimalPattern('id_ID').format(int.parse(listDepoCash[index2].total))}",
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    const Text("Tanggal Top Up : "),
                                    Text((DateFormat('dd-MM-yyyy').format(
                                        listDepoCash[index2].createdAt))),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (index <
                            listAktivasi.length +
                                listDepoCash.length +
                                listDepoKelas.length) {
                          // list deposit kelas
                          final index3 =
                              index - listAktivasi.length - listDepoCash.length;
                          return Card(
                            child: Material(
                              color: const Color.fromARGB(126, 248, 121, 25),
                              borderRadius: BorderRadius.circular(10),
                              child: ListTile(
                                title: const Text("Deposit Kelas"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Pegawai : ${listDepoKelas[index3].pegawai.idPegawai} - ${listDepoKelas[index3].pegawai.namaPegawai}"),
                                    Text(
                                        "No Transaksi : ${listDepoKelas[index3].nomorTransaksi}"),
                                    Text(
                                        "Kelas : ${listDepoKelas[index3].kelas.namaKelas}"),
                                    Text(
                                        "Jumlah Top Up : ${listDepoKelas[index3].depositKelas}"),
                                    Text(
                                        "Masa Berlaku Paket : ${DateFormat('dd-MM-yyyy').format(listDepoKelas[index3].masaBerlaku)}"),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    const Text("Tanggal Top Up : "),
                                    Text((DateFormat('dd-MM-yyyy').format(
                                        listDepoKelas[index3].createdAt))),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          // list booking
                          final index4 = index -
                              listAktivasi.length -
                              listDepoCash.length -
                              listDepoKelas.length;
                          return Card(
                            child: Material(
                              color: const Color.fromARGB(126, 5, 239, 196),
                              borderRadius: BorderRadius.circular(10),
                              child: ListTile(
                                title: const Text("Booking Kelas"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "No Booking : ${listBookingClass[index4].nomorBooking!}"),
                                    Text(
                                        "Kelas : ${listBookingClass[index4].jadwalHarian.kelas.namaKelas}"),
                                    Text(
                                        "Instruktur : ${listBookingClass[index4].jadwalHarian.instruktur.namaInstruktur}"),
                                    Text(
                                        "Metode Bayar : ${listBookingClass[index4].metodePembayaran}"),
                                    listBookingClass[index4].metodePembayaran ==
                                            "Cash"
                                        ? Text(
                                            "Harga Kelas : Rp. ${NumberFormat.decimalPattern('id_ID').format(int.parse(listBookingClass[index4].jadwalHarian.kelas.classDetail.harga))}",
                                          )
                                        : const Text("Paket Berkurang 1"),
                                    // Text("Presensi : " + listBookingClass[index4].member.presensi)
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    const Text("Tanggal Booking : "),
                                    Text((DateFormat('dd-MM-yyyy').format(
                                        listBookingClass[index4]
                                            .waktuBooking!))),
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
