// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/instrukturApi.dart';
import 'package:gofit/pages/history/historyInstruktur.dart';
import 'package:gofit/pages/loginPage.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfilInstruktur extends StatefulWidget {
  const ProfilInstruktur({super.key});

  @override
  State<ProfilInstruktur> createState() => _ProfilInstrukturState();
}

class _ProfilInstrukturState extends State<ProfilInstruktur> {
  late Future instruktur;
  InstrukturApi instrukturApi = InstrukturApi();

  //data instruktur
  int id = 0;
  int? idAbsenInstruktur;
  String namaInstruktur = '';
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
    fetchInstrukturData();
  }

  void fetchInstrukturData() async {
    try {
      var dataInstruktur = await instrukturApi.getInstrukturById();

      DateTime bornDate = DateTime.parse(dataInstruktur['tgl_lahir']);
      String formattedTglLahir = DateFormat('dd-MM-yyyy').format(bornDate);

      DateFormat dateFormat = DateFormat('HH:mm:ss');
      DateTime keterlambatanTime =
          dateFormat.parse(dataInstruktur['keterlambatan']);
      int detik = (keterlambatanTime.hour * 3600) +
          (keterlambatanTime.minute * 60) +
          keterlambatanTime.second;
      setState(() {
        id = dataInstruktur['id'];
        namaInstruktur = dataInstruktur['nama_instruktur'];
        alamat = dataInstruktur['alamat'];
        tglLahir = formattedTglLahir.toString();
        gender = dataInstruktur['gender'];
        noTelp = dataInstruktur['no_telp'];
        email = dataInstruktur['email'];

        keterlambatanToSeconds = detik;
        _items[0] = ProfileInfoItem(
            "Total Terlambat (dalam detik)", keterlambatanToSeconds);
        isLoading = false;
      });
    } catch (error) {
      // ignore: avoid_print
      print('Gagal mengambil data anggota: $error');
    }
  }

  final List<ProfileInfoItem> _items = [
    const ProfileInfoItem("Total Terlambat (dalam detik)", 0),
  ];

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
                          namaInstruktur,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Instruktur",
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
                              label: Text(noTelp),
                              icon: const Icon(Icons.phone),
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
                        const SizedBox(height: 16),
                        // const _ProfileInfoRow(),
                        Container(
                          height: 80,
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _items
                                .map((item) => Expanded(
                                        child: Row(
                                      children: [
                                        if (_items.indexOf(item) != 0)
                                          const VerticalDivider(),
                                        Expanded(
                                            child: _singleItem(context, item)),
                                      ],
                                    )))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const HistoryInstruktur()));
                          },
                          heroTag: 'history',
                          elevation: 0,
                          backgroundColor: Colors.blue,
                          label: const Text("History"),
                          icon: const Icon(Icons.history),
                        ),

                        const SizedBox(height: 10),
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

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      );
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
                            'https://assets.ayobandung.com/crop/0x0:0x0/750x500/webp/photo/2022/06/21/3834051622.jpg')),
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
