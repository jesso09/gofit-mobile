// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/memberApi.dart';
import 'package:gofit/pages/history/historyMember.dart';
import 'package:gofit/pages/loginPage.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfileMember extends StatefulWidget {
  const ProfileMember({super.key});

  @override
  State<ProfileMember> createState() => _ProfileMemberState();
}

class _ProfileMemberState extends State<ProfileMember> {
  late Future member;
  MemberApi memberApi = MemberApi();
  int id = 0;
  String idMember = '';
  String nama = '';
  String status = '';
  String depositCash = '';
  String depositKelas = '';
  String? masaBerlaku;
  String gender = '';
  String alamat = '';
  String tglLahir = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMemberData();
  }

  void fetchMemberData() async {
    try {
      var dataMember = await memberApi.getMemberById();

      DateTime bornDate = DateTime.parse(dataMember['tgl_lahir']);
      String formattedTglLahir = DateFormat('dd-MM-yyyy').format(bornDate);

      if (dataMember['masa_berlaku'] != null) {
        DateTime? masaBerlakuData =
            DateTime.tryParse(dataMember['masa_berlaku']);
        masaBerlaku = masaBerlakuData != null
            ? DateFormat('dd-MM-yyyy').format(masaBerlakuData)
            : "Belum Aktivasi";
      } else {
        masaBerlaku = "Belum Aktivasi";
      }

      setState(() {
        id = dataMember['id'];
        idMember = dataMember['id_member'];
        nama = dataMember['nama'];
        status = dataMember['status'];
        tglLahir = formattedTglLahir.toString();
        gender = dataMember['gender'];
        alamat = dataMember['alamat'];
        depositCash = dataMember['deposit_cash'];
        depositKelas = dataMember['deposit_kelas'];
        _items[0] = ProfileInfoItem(
            "Deposit Cash",
            NumberFormat.decimalPattern('id_ID')
                .format(int.parse(depositCash)));
        _items[1] = ProfileInfoItem("Deposit Kelas", depositKelas);
        isLoading = false;
      });
    } catch (error) {
      // ignore: avoid_print
      print('Gagal mengambil data anggota: $error');
    }
  }

  final List<ProfileInfoItem> _items = [
    const ProfileInfoItem("Deposit Cash", '0'),
    const ProfileInfoItem("Deposit Kelas", '0'),
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
                          nama,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Member",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          gender,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          "Berlaku Hingga : $masaBerlaku",
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
                              label: Text(idMember),
                              icon: const Icon(Icons.person),
                              backgroundColor: const Color(0xFFFFC300),
                            ),
                            const SizedBox(width: 16.0),
                            FloatingActionButton.extended(
                              onPressed: () {},
                              heroTag: 'status',
                              elevation: 0,
                              backgroundColor: Colors.lightBlue,
                              label: Text(status),
                              icon:
                                  const Icon(Icons.chrome_reader_mode_rounded),
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
                                builder: (context) => const HistoryMember()));
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

// class _ProfileInfoRow extends StatelessWidget {
//   const _ProfileInfoRow({Key? key}) : super(key: key);

//   final List<ProfileInfoItem> _items = const [
//     ProfileInfoItem("Deposit Cash", 900),
//     ProfileInfoItem("Deposit Kelas", 120),
//     ProfileInfoItem("Masa Berlaku", 200),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 80,
//       constraints: const BoxConstraints(maxWidth: 400),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: _items
//             .map((item) => Expanded(
//                     child: Row(
//                   children: [
//                     if (_items.indexOf(item) != 0) const VerticalDivider(),
//                     Expanded(child: _singleItem(context, item)),
//                   ],
//                 )))
//             .toList(),
//       ),
//     );
//   }

//   Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               item.value.toString(),
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//           ),
//           Text(
//             item.title,
//             style: Theme.of(context).textTheme.caption,
//           )
//         ],
//       );
// }

class ProfileInfoItem {
  final String title;
  final String value;
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
                            'https://i.pinimg.com/originals/57/88/a5/5788a5963d1009e21a9c32acdd7d6214.jpg')),
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
