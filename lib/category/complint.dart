import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/allDatabase.dart';
import 'package:stayez/color.dart';

class ComplaintBoxScreen extends StatefulWidget {
  @override
  _ComplaintBoxScreenState createState() => _ComplaintBoxScreenState();
}

class _ComplaintBoxScreenState extends State<ComplaintBoxScreen> {
  final _formKey = GlobalKey<FormState>();

  // List of complaint names
  final List<String> complaintNames = [
    'Service Issue',
    'Billing Problem',
    'Product Defect',
  ];

  final TextEditingController roomNoController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('roomNo');
    setState(() {
      roomNoController.text = savedData ?? 'no data';
    });
  }
  String? _selectedComplaint;
  String? _complaintDetails;
  // String? _roomNo; // Room number variable

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
              'Complaint Box',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Room Number Text Field
                  Text(
                    'Room No',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    controller: roomNoController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: white,
                      hintText: 'Enter your room number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your room number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Dropdown for selecting the complaint name
                  Text(
                    'Select Complaint Type',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: _selectedComplaint,
                    hint: Text('Choose a complaint'),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedComplaint = newValue;
                      });
                    },
                    items: complaintNames.map((complaintName) {
                      return DropdownMenuItem(
                        value: complaintName,
                        child: Text(complaintName),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a complaint type';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Long text box for entering complaint details
                  Text(
                    'Complaint Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: white,
                      hintText: 'Describe your issue...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 5,
                    onChanged: (value) {
                      _complaintDetails = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your complaint details';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),

                  // Send button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Save the data to the database
                          Map<String, String> complaintData = {
                            'room_no': roomNoController.text,
                            'complaint_type': _selectedComplaint!,
                            'complaint_details': _complaintDetails!,
                          };
                          await DatabaseHelper().insertComplaint(complaintData);

                          // Show a confirmation message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Complaint Submitted')),
                          );
                        }
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(
                          fontSize: 22,
                          color: black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
