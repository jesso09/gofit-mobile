// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/globalApi.dart';
import 'package:gofit/api/memberApi.dart';
import '../../model/member.dart';
import '../profile/profileMo.dart';
import '../show/showJadwalHarian.dart';

class HomeMo extends StatefulWidget {
  const HomeMo({super.key});

  @override
  State<HomeMo> createState() => _HomeMoState();
}

class _HomeMoState extends State<HomeMo> {
  MemberApi memberApi = MemberApi();
  late Future member;
  List<Member> listMember = [];
  bool isLoading = true;
  int _selectedIndex = GlobalVariables.indexPageMo;

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
      GlobalVariables.indexPageMo = _selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          GlobalVariables.indexPageMo == 0 ? "Home Page" : "Jadwal Hari Ini",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff000814),
        automaticallyImplyLeading: false,
      ),
      body: GlobalVariables.indexPageMo == 0
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
          : GlobalVariables.indexPageMo == 1
              ? const ShowJadwalHarian()
              : const ProfileMo(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_sharp),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xff000814),
        selectedItemColor: const Color(0xFFFFC300),
        selectedIconTheme: const IconThemeData(color: Color(0xFFFFC300)),
        unselectedIconTheme: const IconThemeData(color: Colors.white),
        onTap: _onItemTapped,
      ),
    );
  }
}
