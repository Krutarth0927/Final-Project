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
  void updateStaffMember(StaffMember updatedStaff) {
    setState(() {
      final staff = staffMembers.firstWhere((s) => s.id == updatedStaff.id);
      staff.name = updatedStaff.name;
      staff.role = updatedStaff.role;
      staff.phone = updatedStaff.phone;
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
class AddStaffPage extends StatefulWidget {
  final Function(StaffMember) onStaffAdded;
  final List<StaffMember> staffMembers;

  AddStaffPage({required this.onStaffAdded, required this.staffMembers});

  @override
  _AddStaffPageState createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Add form key for validation

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
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Use form key to handle validation
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    } else if (value.length < 2) {
                      return "Name must be at least 2 characters";
                    } else if (RegExp(r'[0-9]').hasMatch(value)) {
                      return "Name cannot contain numbers";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _roleController,
                  decoration: InputDecoration(labelText: "Role"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Role is required";
                    } else if (value.length < 2) {
                      return "Role must be at least 2 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Phone Number"),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number is required";
                    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return "Phone number must be exactly 10 digits";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final staff = StaffMember(
                        id: widget.staffMembers.isNotEmpty
                            ? widget.staffMembers.last.id + 1
                            : 1,
                        name: _nameController.text,
                        role: _roleController.text,
                        phone: _phoneController.text,
                      );
                      widget.onStaffAdded(staff);
                      Navigator.of(context).pop();
                    }
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
      ),
    );
  }
}
class EditStaffPage extends StatefulWidget {
  final StaffMember staff;
  final Function(StaffMember) onStaffUpdated; // Expecting StaffMember

  EditStaffPage({required this.staff, required this.onStaffUpdated});

  @override
  _EditStaffPageState createState() => _EditStaffPageState();
}

class _EditStaffPageState extends State<EditStaffPage> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _phoneController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.staff.name);
    _roleController = TextEditingController(text: widget.staff.role);
    _phoneController = TextEditingController(text: widget.staff.phone);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text("Edit Staff Member"),
          backgroundColor: accentColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(

            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    } else if (value.length < 2) {
                      return "Name must be at least 2 characters";
                    } else if (RegExp(r'[0-9]').hasMatch(value)) {
                      return "Name cannot contain numbers";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _roleController,
                  decoration: InputDecoration(labelText: "Role"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Role is required";
                    } else if (value.length < 2) {
                      return "Role must be at least 2 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Phone Number"),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number is required";
                    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return "Phone number must be exactly 10 digits";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Create updated StaffMember object
                      final updatedStaff = StaffMember(
                        id: widget.staff.id,
                        name: _nameController.text,
                        role: _roleController.text,
                        phone: _phoneController.text,
                      );
                      widget.onStaffUpdated(updatedStaff); // Pass updated object
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor
                  ),
                  child: Text("Update Staff",style: TextStyle(color: black),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
