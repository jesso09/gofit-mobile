// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gofit/api/globalApi.dart';
import 'package:gofit/api/memberApi.dart';
import 'package:gofit/pages/profile/profileMember.dart';
import 'package:gofit/pages/show/showBookingClass.dart';

import '../../model/member.dart';
import '../show/showJadwalUmum.dart';

class HomeMember extends StatefulWidget {
  const HomeMember({super.key});

  @override
  State<HomeMember> createState() => _HomeMemberState();
}

class _HomeMemberState extends State<HomeMember> {
  MemberApi memberApi = MemberApi();
  late Future member;
  List<Member> listMember = [];
  bool isLoading = true;
  int _selectedIndex = GlobalVariables.indexPageMember;

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
      GlobalVariables.indexPageMember = _selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          GlobalVariables.indexPageMember == 0
              ? "Home Page"
              : GlobalVariables.indexPageMember == 1
                  ? "Jadwal Umum"
                  : GlobalVariables.indexPageMember == 2
                      ? "Booking Kelas"
                      : "",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff000814),
        automaticallyImplyLeading: false,
      ),
      body: GlobalVariables.indexPageMember == 0
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
          : GlobalVariables.indexPageMember == 1
              ? const ShowJadwalUmum()
              : GlobalVariables.indexPageMember == 2
                  ? const ShowBookingClass()
                  : const ProfileMember(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xff000814),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Jadwal',
            backgroundColor: Color(0xff000814),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_add_rounded),
            label: 'Booking',
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
