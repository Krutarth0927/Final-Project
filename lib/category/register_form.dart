import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayez/category/register_table.dart';
import 'package:stayez/color.dart';
import 'package:stayez/database/allDatabase.dart';

class DailyRegisterForm extends StatefulWidget {


  @override
  _DailyRegisterFormState createState() => _DailyRegisterFormState();
}
class _DailyRegisterFormState extends State<DailyRegisterForm> {
  @override
  void initState() {
    super.initState();
    _loadRoomNumber(); // Load room number when the widget is initialized
  }

  Future<void> _loadRoomNumber() async {
    // Get shared preferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Load the saved room number
    String? roomNo = prefs.getString('roomNo');
    setState(() {
      roomNoController.text = roomNo ?? ''; // Set the loaded room number
    });
  }



  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final roomNoController = TextEditingController();
  final entryTimeController = TextEditingController();
  final exitTimeController = TextEditingController();
  final reasonController = TextEditingController();

  // Get the current date.
  final String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 35),
                child: Text(
                  "Daily Register",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
          backgroundColor: accentColor,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Fill in the details",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextFormField(
                    controller: nameController,
                    labelText: "Name",
                    icon: Icons.person,
                  ),
                  SizedBox(height: 20),
                  _buildTextFormField(
                    controller: roomNoController, // This is the controller for the Room No field
                    labelText: "Room No",
                    icon: Icons.meeting_room,
                    keyboardType: TextInputType.number, // Numeric input
                  ),
                  SizedBox(height: 20),
                  _buildDateField(
                    labelText: "Date",
                    icon: Icons.calendar_today,
                    date: currentDate, // Display current date
                  ),
                  SizedBox(height: 20),
                  _buildTimeField(
                    controller: entryTimeController,
                    labelText: "Entry Time",
                    icon: Icons.access_time,
                  ),
                  SizedBox(height: 20),
                  _buildTimeField(
                    controller: exitTimeController,
                    labelText: "Exit Time",
                    icon: Icons.exit_to_app,
                  ),
                  SizedBox(height: 20),
                  _buildTextFormField(
                    controller: reasonController,
                    labelText: "Reason",
                    icon: Icons.text_snippet,
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          DatabaseHelper.instance.insertRegister({
                            'name': nameController.text,
                            'room_no': roomNoController.text,
                            'entry_date_time':
                            '$currentDate ${entryTimeController.text}',
                            'exit_date_time':
                            '$currentDate ${exitTimeController.text}',
                            'reason': reasonController.text,
                          }).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Data Saved')),
                            );
                          });
                          // Clear all the fields after successful submission
                          nameController.clear();
                          roomNoController.clear();
                          entryTimeController.clear();
                          exitTimeController.clear();
                          reasonController.clear();
                        }
                      },
                      child: Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: black,
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterTable()),
                        );
                      },
                      child: Text("View Entries",
                          style: TextStyle(
                              fontSize: 18,
                              color: black,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text, // Default to text input
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType, // Set keyboard type
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: black),
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildTimeField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true, // Make the field read-only
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: black),
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            controller.text = pickedTime.format(context);
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  // Widget for the Date field
  Widget _buildDateField({
    required String labelText,
    required IconData icon,
    required String date,
  }) {
    return TextFormField(
      initialValue: date,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: black),
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
    );
  }
}
