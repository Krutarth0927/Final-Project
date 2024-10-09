import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayez/adminDashboard/roomallocation.dart';
import 'package:stayez/color.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late final List<Room> rooms;

  Future<void> _loadRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final String? roomsJson = prefs.getString('rooms');
    if (roomsJson != null) {
      final List<dynamic> decoded = jsonDecode(roomsJson);
      setState(() {
        rooms = decoded.map((room) => Room.fromJson(room)).toList();
        // print("\n\n\nrooms");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRooms();
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
                  "Student Room View",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
        ),
        body: ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            return SizedBox(
              height: 70,
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 38.0),
                child: Card(
                  color: accentColor,
                  child: ListTile(
                    title: Text("Room ${room.number} - Beds: ${room.beds}"),
                    subtitle:
                    Text(room.isAvailable ? "Available" : "Not Available"),
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
