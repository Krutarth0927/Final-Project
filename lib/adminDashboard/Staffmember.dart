import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayez/category/staffmember.dart';
import 'package:stayez/color.dart';

class AdminStaffMemberPage extends StatefulWidget {
  @override
  _AdminStaffMemberPageState createState() => _AdminStaffMemberPageState();
}

class _AdminStaffMemberPageState extends State<AdminStaffMemberPage> {
  List<StaffMember> staffMembers = [];

  @override
  void initState() {
    super.initState();
    _loadStaffMembers();
  }

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

  Future<void> _saveStaffMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> staffJson =
        staffMembers.map((staff) => staff.toJson()).toList();
    await prefs.setString('staffMembers', jsonEncode(staffJson));
  }

  void addStaffMember(StaffMember staff) {
    setState(() {
      staffMembers.add(staff);
      _saveStaffMembers();
    });
  }

  void updateStaffMember(
      int staffId, String newName, String newRole, String newPhone) {
    setState(() {
      final staff = staffMembers.firstWhere((s) => s.id == staffId);
      staff.name = newName;
      staff.role = newRole;
      staff.phone = newPhone;
      _saveStaffMembers();
    });
  }

  void deleteStaffMember(int staffId) {
    setState(() {
      staffMembers.removeWhere((s) => s.id == staffId);
      _saveStaffMembers();
    });
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
            "Staff Management",
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
                    builder: (context) => StaffPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: staffMembers.length,
          itemBuilder: (context, index) {
            final staff = staffMembers[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: accentColor,
                child: ListTile(
                  title: Text("Name: ${staff.name}"),
                  subtitle: Text("Role: ${staff.role} \nPhone: ${staff.phone}"),
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
                              builder: (context) => EditStaffPage(
                                staff: staff,
                                onStaffUpdated: updateStaffMember,
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
                        onPressed: () => deleteStaffMember(staff.id),
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
                builder: (context) => AddStaffPage(
                    onStaffAdded: addStaffMember, staffMembers: staffMembers),
              ),
            );
          },
          child: Icon(Icons.add, color: black),
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

class AddStaffPage extends StatelessWidget {
  final Function(StaffMember) onStaffAdded;
  final List<StaffMember> staffMembers;

  AddStaffPage({required this.onStaffAdded, required this.staffMembers});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
              "Add Staff Member",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _roleController,
                decoration: InputDecoration(labelText: "Role"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final staff = StaffMember(
                    id: staffMembers.isNotEmpty
                        ? staffMembers.last.id + 1
                        : 1, // Increment the ID based on existing staff members
                    name: _nameController.text,
                    role: _roleController.text,
                    phone: _phoneController.text,
                  );
                  onStaffAdded(staff);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Add Staff",
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

class EditStaffPage extends StatelessWidget {
  final StaffMember staff;
  final Function(int, String, String, String) onStaffUpdated;

  EditStaffPage({required this.staff, required this.onStaffUpdated});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = staff.name;
    _roleController.text = staff.role;
    _phoneController.text = staff.phone;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: accentColor,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 35),
              child: Text(
                "Edit Staff Member",
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
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _roleController,
                decoration: InputDecoration(labelText: "Role"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  onStaffUpdated(staff.id, _nameController.text,
                      _roleController.text, _phoneController.text);
                  Navigator.of(context).pop();
                },
                child: Text("Update Staff", style: TextStyle(color: black)),
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
