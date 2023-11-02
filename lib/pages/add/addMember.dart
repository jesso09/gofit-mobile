// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:gofit/api/memberApi.dart';

import '../../model/member.dart';

class AddMember extends StatefulWidget {
  const AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  int count = 0;
  MemberApi memberApi = MemberApi();
  late Future members;
  Member? member;
  List<Member> listMember = [];
  int totalMember = 0;
  @override
  void initState() {
    super.initState();
    members = memberApi.getMember();
    members.then((value) {
      setState(() {
        listMember = value;
      });
    });
    totalMember = listMember.length;
    // print(totalMember);
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedGender;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Pria", child: Text("Pria")),
      const DropdownMenuItem(value: "Wanita", child: Text("Wanita")),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Test Add Page"),
          backgroundColor: Colors.amber,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Nama"),
                  textInputAction: TextInputAction.next,
                  controller: nameController,
                ),

                const SizedBox(height: 10),
                TextFormField(
                  autocorrect: false,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Alamat"),
                  textInputAction: TextInputAction.next,
                  controller: alamatController,
                ),

                const SizedBox(height: 10),
                TextFormField(
                  autocorrect: false,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Tanggal Lahir"),
                  textInputAction: TextInputAction.next,
                  controller: tglLahirController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        tglLahirController.text =
                            formattedDate; //set output date to TextField value.
                      });
                    }
                  },
                ),

                const SizedBox(height: 10),
                TextFormField(
                  autocorrect: false,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "No. Telp"),
                  textInputAction: TextInputAction.next,
                  controller: noTelpController,
                ),

                const SizedBox(height: 10),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Gender"),
                  items: dropdownItems,
                  value: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                ),

                const SizedBox(height: 10),
                TextFormField(
                  autocorrect: false,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Email"),
                  textInputAction: TextInputAction.next,
                  controller: emailController,
                ),
                //Save Button
                const SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      memberApi
                          .addMember(
                              nameController.text,
                              alamatController.text,
                              tglLahirController.text,
                              noTelpController.text,
                              selectedGender,
                              emailController.text)
                          .then((value) {
                        setState(() {
                          if (value) {
                            Alert(
                                context: context,
                                title: "Data Added",
                                type: AlertType.success,
                                buttons: [
                                  DialogButton(
                                      child: const Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .popUntil((_) => count++ >= 2);
                                      }),
                                ]).show();
                          } else {
                            Alert(
                                context: context,
                                title: "Failed Adding Data",
                                type: AlertType.error,
                                buttons: [
                                  DialogButton(
                                      child: const Text("OK"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ]).show();
                          }
                        });
                      });
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ));
  }
}
