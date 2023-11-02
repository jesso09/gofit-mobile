// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/globalApi.dart';
import 'package:gofit/api/memberApi.dart';
import 'package:gofit/pages/profile/profileInstruktur.dart';
import 'package:gofit/pages/show/showIzinInstruktur.dart';
import '../../model/member.dart';
import '../show/showKelasInstruktur.dart';

class HomeInstruktur extends StatefulWidget {
  const HomeInstruktur({super.key});

  @override
  State<HomeInstruktur> createState() => _HomeInstrukturState();
}

class _HomeInstrukturState extends State<HomeInstruktur> {
  MemberApi memberApi = MemberApi();
  late Future member;
  List<Member> listMember = [];
  bool isLoading = true;
  int _selectedIndex = GlobalVariables.indexPageInstruktur;

  void refreshData() {
    member = memberApi.getMember();
    member.then((value) {
      setState(() {
        listMember = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    member = memberApi.getMember();
    member.then((value) {
      setState(() {
        listMember = value;
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      GlobalVariables.indexPageInstruktur = _selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          GlobalVariables.indexPageInstruktur == 0
              ? "Home Page"
              : GlobalVariables.indexPageInstruktur == 1
                  ? "Jadwal Hari Ini"
                  : GlobalVariables.indexPageInstruktur == 2
                      ? "Daftar Izin"
                      : "",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff000814),
        // backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: GlobalVariables.indexPageInstruktur == 0
          ? Stack(children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/transparent-logo.png'),
                    scale: 2,
                  ),
                ),
              )
            ])
          : GlobalVariables.indexPageInstruktur == 1
              ? const ShowKelasInstruktur()
              : GlobalVariables.indexPageInstruktur == 2
                  ? const ShowIzinInstruktur()
                  : const ProfilInstruktur(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xff000814),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Presensi Member',
            backgroundColor: Color(0xff000814),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket_rounded),
            label: 'Izin',
            backgroundColor: Color(0xff000814),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Color(0xff000814),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFFC300),
        onTap: _onItemTapped,
      ),
    );
  }
}
