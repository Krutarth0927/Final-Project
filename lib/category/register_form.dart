import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for formatting dates and times.
import 'package:shared_preferences/shared_preferences.dart';
import '../database/allDatabase.dart';
import 'package:stayez/color.dart';
import 'register_table.dart';

class DailyRegisterForm extends StatefulWidget {
  @override
  _DailyRegisterFormState createState() => _DailyRegisterFormState();
}

class _DailyRegisterFormState extends State<DailyRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final roomNoController = TextEditingController();
  final entryTimeController = TextEditingController();
  final exitTimeController = TextEditingController();
  final reasonController = TextEditingController();

  // Get the current date.
  final String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('roomNo');
    String? savedData1 = prefs.getString('fullName');
    setState(() {
      nameController.text = savedData1 ?? 'no data';
      roomNoController.text = savedData ?? 'no data';
    });
  }

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

                  // Name field (Editable)
                  _buildTextFormField(
                    controller: nameController,
                    labelText: "Name",
                    icon: Icons.person,
                  ),
                  SizedBox(height: 20),

                  // Room No field (Editable)
                  _buildTextFormField(
                    controller: roomNoController,
                    labelText: "Room No",
                    icon: Icons.meeting_room,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),

                  // Date field (Read-only)
                  _buildDateField(
                    labelText: "Date",
                    icon: Icons.calendar_today,
                    date: currentDate, // Display current date
                  ),
                  SizedBox(height: 20),

                  // Entry Time field (Read-only with picker)
                  _buildTimeField(
                    controller: entryTimeController,
                    labelText: "Entry Time",
                    icon: Icons.access_time,
                  ),
                  SizedBox(height: 20),

                  // Exit Time field (Read-only with picker)
                  _buildTimeField(
                    controller: exitTimeController,
                    labelText: "Exit Time",
                    icon: Icons.exit_to_app,

                  ),
                  SizedBox(height: 20),

                  // Reason field (Read-only)
                  _buildTextFormField(
                    controller: reasonController,
                    labelText: "Reason",
                    icon: Icons.text_snippet,
                    readOnly: false, // Make this field read-only
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

  // Widget to build text form fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text, // Default to text input
    bool readOnly = true, // Add a readOnly property (default false)
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly, // Set field as read-only if needed
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

  // Widget for the Time field (already read-only with a picker)
  Widget _buildTimeField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool isExitTime = false,
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

        // Exit Time Validation: Ensure Exit Time is not before Entry Time
        if (isExitTime) {
          TimeOfDay entryTime = TimeOfDay.now(); // Default current time
          if (entryTimeController.text.isNotEmpty) {
            // Parse the entry time if it exists
            entryTime = _parseTime(entryTimeController.text);
          }

          TimeOfDay exitTime = _parseTime(controller.text);

          // Compare Entry Time and Exit Time
          if (_isTimeBefore(exitTime, entryTime)) {
            return 'Exit time must be after entry time';
          }
        }

        return null;
      },
    );
  }

// Helper function to parse time string (HH:mm) to TimeOfDay
  TimeOfDay _parseTime(String time) {
    final format = DateFormat.jm(); // HH:mm
    DateTime dateTime = format.parse(time);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

// Helper function to compare two TimeOfDay objects
  bool _isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    final now = DateTime.now();
    final dateTime1 = DateTime(now.year, now.month, now.day, time1.hour, time1.minute);
    final dateTime2 = DateTime(now.year, now.month, now.day, time2.hour, time2.minute);

    return dateTime1.isBefore(dateTime2);
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
