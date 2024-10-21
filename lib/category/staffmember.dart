import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayez/color.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  late List<StaffMember> staffMembers;

  Future<void> _loadStaffMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? staffJson = prefs.getString('staffMembers');
    if (staffJson != null) {
      final List<dynamic> decoded = jsonDecode(staffJson);
      setState(() {
        staffMembers =
            decoded.map((staff) => StaffMember.fromJson(staff)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadStaffMembers();
  }

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: accentColor,
          title: Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 35.0),
            child: Text(
              "Staff Members",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
        ),
        body: ListView.builder(
          itemCount: staffMembers.length,
          itemBuilder: (context, index) {
            final staff = staffMembers[index];
            return SizedBox(
              height: 120,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: accentColor,
                  child: ListTile(
                    title: Text("Name: ${staff.name}"),
                    subtitle: Text(
                      "Role: ${staff.role}\nPhone: ${staff.phone}",
                      style: TextStyle(
                          color: black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () => _launchPhone(
                        staff.phone), // Make phone number clickable
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StaffMember {
  final int id;
  String name;
  String role;
  String phone;

  StaffMember({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
  });

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'phone': phone,
    };
  }
}
