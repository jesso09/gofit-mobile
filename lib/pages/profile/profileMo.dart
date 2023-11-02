// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/pegawaiApi.dart';
import 'package:gofit/pages/loginPage.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfileMo extends StatefulWidget {
  const ProfileMo({super.key});

  @override
  State<ProfileMo> createState() => _ProfileMoState();
}

class _ProfileMoState extends State<ProfileMo> {
  late Future pegawai;
  PegawaiApi pegawaiApi = PegawaiApi();

  //data instruktur
  int id = 0;
  String idPegawai = "";
  String nama = '';
  String alamat = '';
  String tglLahir = '';
  String gender = '';
  String noTelp = '';
  String email = '';
  String password = '';
  int keterlambatanToSeconds = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPegawaiData();
  }

  void fetchPegawaiData() async {
    try {
      var dataPegawai = await pegawaiApi.getPegawaiById();

      DateTime bornDate = DateTime.parse(dataPegawai['tgl_lahir']);
      String formattedTglLahir = DateFormat('dd-MM-yyyy').format(bornDate);

      setState(() {
        id = dataPegawai['id'];
        idPegawai = dataPegawai['id_pegawai'];
        nama = dataPegawai['nama_pegawai'];
        alamat = dataPegawai['alamat'];
        tglLahir = formattedTglLahir.toString();
        gender = dataPegawai['gender'];
        noTelp = dataPegawai['no_telp'];
        email = dataPegawai['email'];
      });
      isLoading = false;
    } catch (error) {
      // ignore: avoid_print
      print('Gagal mengambil data anggota: $error');
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
          : Column(
              children: [
                const Expanded(flex: 2, child: _TopPortion()),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          nama,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Manager Operasional",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          gender,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          "Tanggal Lahir : $tglLahir",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton.extended(
                              onPressed: () {},
                              heroTag: 'role',
                              elevation: 0,
                              label: Text(idPegawai),
                              icon: const Icon(Icons.person),
                              backgroundColor: const Color(0xFFFFC300),
                            ),
                            const SizedBox(width: 16.0),
                            FloatingActionButton.extended(
                              onPressed: () {},
                              heroTag: 'status',
                              elevation: 0,
                              backgroundColor: Colors.lightBlue,
                              label: Text(email),
                              icon: const Icon(Icons.email),
                            ),
                          ],
                        ),
                        const SizedBox(height: 70),
                        FloatingActionButton.extended(
                          onPressed: () {
                            Alert(
                                context: context,
                                style: AlertStyle(
                                  backgroundColor: Colors.white,
                                  isCloseButton: false,
                                  alertBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: const BorderSide(
                                      color: Color(0xff000814),
                                      width: 4,
                                    ),
                                  ),
                                  descStyle: const TextStyle(fontSize: 14),
                                ),
                                title: "Log Out",
                                desc: "Are you sure you want to log out?",
                                type: AlertType.info,
                                buttons: [
                                  DialogButton(
                                      radius: BorderRadius.circular(10),
                                      color: Colors.green,
                                      child: const Text(
                                        "Log Out",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login()),
                                        );
                                      }),
                                  DialogButton(
                                      radius: BorderRadius.circular(10),
                                      color: Colors.red,
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ]).show();
                          },
                          heroTag: 'logout',
                          elevation: 0,
                          backgroundColor: Colors.red,
                          label: const Text("Logout"),
                          icon: const Icon(Icons.logout),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.lightBlue,
                    Color(0xff003566),
                    Color(0xff000814)
                  ]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://otakotaku.com/asset/img/character/2020/12/nobara-kugisaki-5fc78f91b43e9p.jpg')),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
