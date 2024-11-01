import 'dart:convert'; // For jsonEncode and jsonDecode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayez/Dashboard/roomBooking.dart';

import 'package:stayez/color.dart';

class AdminRoomManagementPage extends StatefulWidget {
  @override
  _AdminRoomManagementPageState createState() =>
      _AdminRoomManagementPageState();
}

class _AdminRoomManagementPageState extends State<AdminRoomManagementPage> {
  List<Room> rooms = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final String? roomsJson = prefs.getString('rooms');
    if (roomsJson != null) {
      final List<dynamic> decoded = jsonDecode(roomsJson);
      setState(() {
        rooms = decoded.map((room) => Room.fromJson(room)).toList();
      });
    }
  }

  Future<void> _saveRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> roomsJson =
        rooms.map((room) => room.toJson()).toList();
    await prefs.setString('rooms', jsonEncode(roomsJson));
  }

  void toggleRoomAvailability(int roomId) {
    setState(() {
      final room = rooms.firstWhere((r) => r.id == roomId);
      room.isAvailable = !room.isAvailable;
      _saveRooms();
    });
  }

  void addRoom(Room room) {
    setState(() {
      rooms.add(room);
      _saveRooms();
    });
  }

  void updateRoom(int roomId, String newNumber, int newBeds) {
    setState(() {
      final room = rooms.firstWhere((r) => r.id == roomId);
      room.number = newNumber;
      room.beds = newBeds;
      _saveRooms();
    });
  }

  void deleteRoom(int roomId) {
    setState(() {
      rooms.removeWhere((r) => r.id == roomId);
      _saveRooms();
    });
  }

  int getTotalRoomCount() {
    return rooms.length;
  }

  int getAvailableRoomCount() {
    return rooms.where((room) => room.isAvailable).length;
  }

  int getUnavailableRoomCount() {
    return rooms.where((room) => !room.isAvailable).length;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: accentColor,
          title: Center(
              child: Text(
            "Room Management",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          actions: [
            IconButton(
              icon: Icon(
                Icons.people,
                color: black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: accentColor,
                child: ListTile(
                  title: Text("Room ${room.number} - Beds: ${room.beds}"),
                  subtitle:
                      Text(room.isAvailable ? "Available" : "Not Available"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditRoomPage(
                                room: room,
                                onRoomUpdated: updateRoom,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: black,
                        ),
                        onPressed: () => deleteRoom(room.id),
                      ),
                      IconButton(
                        icon: Icon(
                          room.isAvailable
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: room.isAvailable ? Colors.black : Colors.black,
                        ),
                        onPressed: () => toggleRoomAvailability(room.id),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: buttonColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddRoomPage(onRoomAdded: addRoom, rooms: rooms),
              ),
            );
          },
          child: Icon(Icons.add, color: black),
        ),
      ),
    );
  }
}

class Room {
  final int id;
  String number;
  bool isAvailable;
  int beds;

  Room({
    required this.id,
    required this.number,
    required this.isAvailable,
    required this.beds,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      number: json['number'],
      isAvailable: json['isAvailable'],
      beds: json['beds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'isAvailable': isAvailable,
      'beds': beds,
    };
  }
}

class AddRoomPage extends StatelessWidget {
  final Function(Room) onRoomAdded;
  final List<Room> rooms;

  AddRoomPage({required this.onRoomAdded, required this.rooms});

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _bedsController = TextEditingController();

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _numberController.dispose();
    _bedsController.dispose();

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
                padding: const EdgeInsets.only(right: 35),
                child: Text(
                  "Add Room",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _numberController,
                decoration: InputDecoration(labelText: "Room Number"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _bedsController,
                decoration: InputDecoration(labelText: "Number of Beds"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_numberController.text.isEmpty) {
                    showError(context, "Room number is required");
                    return;
                  }

                  if (int.tryParse(_bedsController.text) == null ||
                      int.parse(_bedsController.text) <= 0) {
                    showError(context, "Beds must be a positive integer");
                    return;
                  }

                  final room = Room(
                    id: rooms.isNotEmpty ? rooms.last.id + 1 : 1,
                    number: _numberController.text,
                    isAvailable: true,
                    beds: int.parse(_bedsController.text),
                  );
                  onRoomAdded(room);
                  Navigator.of(context).pop();
                },
                child: Text("Add Room", style: TextStyle(color: black)),
                style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class EditRoomPage extends StatelessWidget {
  final Room room;
  final Function(int, String, int) onRoomUpdated;

  EditRoomPage({required this.room, required this.onRoomUpdated});

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _bedsController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    _bedsController.dispose();

      }

  @override
  Widget build(BuildContext context) {
    _numberController.text = room.number;
    _bedsController.text = room.beds.toString();

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: accentColor,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 35),
              child: Text(
                "Edit Room",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _numberController,
                decoration: InputDecoration(labelText: "Room Number"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _bedsController,
                decoration: InputDecoration(labelText: "Number of Beds"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  onRoomUpdated(room.id, _numberController.text,
                      int.parse(_bedsController.text));
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Update Room",
                  style: TextStyle(color: black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
