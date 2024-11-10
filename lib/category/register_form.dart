import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  bool isExitTimeEnabled = false; // New variable to control exit time field

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

                  // Name field
                  _buildTextFormField(
                    controller: nameController,
                    labelText: "Name",
                    icon: Icons.person,
                  ),
                  SizedBox(height: 20),

                  // Room No field
                  _buildTextFormField(
                    controller: roomNoController,
                    labelText: "Room No",
                    icon: Icons.meeting_room,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),

                  // Date field
                  _buildDateField(
                    labelText: "Date",
                    icon: Icons.calendar_today,
                    date: currentDate,
                  ),
                  SizedBox(height: 20),

                  // Entry Time field
                  _buildTimeField(
                    controller: entryTimeController,
                    labelText: "Entry Time",
                    icon: Icons.access_time,
                    onTimePicked: (TimeOfDay pickedTime) {
                      setState(() {
                        isExitTimeEnabled = true;
                        entryTimeController.text = pickedTime.format(context);
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  // Exit Time field
                  _buildTimeField(
                    controller: exitTimeController,
                    labelText: "Exit Time",
                    icon: Icons.exit_to_app,
                    enabled: isExitTimeEnabled,
                    isExitTime: true,
                  ),
                  SizedBox(height: 20),

                  // Reason field
                  _buildTextFormField(
                    controller: reasonController,
                    labelText: "Reason",
                    icon: Icons.text_snippet,
                    readOnly: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a reason';
                      }
                      if (RegExp(r'[0-9]').hasMatch(value) ||
                          value.trim().isEmpty) {
                        return 'Reason cannot contain numbers or be only spaces';
                      }
                      return null;
                    },
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
                          entryTimeController.clear();
                          exitTimeController.clear();
                          reasonController.clear();
                          setState(() {
                            isExitTimeEnabled = false; // Reset exit time field
                          });
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
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
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
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $labelText';
            }
            if (labelText == "Name" &&
                (RegExp(r'[0-9]').hasMatch(value) || value.trim().isEmpty)) {
              return 'Name cannot contain numbers or spaces only';
            }
            return null;
          },
    );
  }

  Widget _buildTimeField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool enabled = true,
    bool isExitTime = false,
    void Function(TimeOfDay)? onTimePicked,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      enabled: enabled,
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
      onTap: enabled
          ? () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                if (isExitTime && entryTimeController.text.isNotEmpty) {
                  TimeOfDay entryTime = _parseTime(entryTimeController.text);
                  if (_isTimeBefore(pickedTime, entryTime)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Exit time must be after entry time')),
                    );
                  } else if (pickedTime == entryTime) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Exit time cannot be the same as entry time')),
                    );
                  } else {
                    controller.text = pickedTime.format(context);
                  }
                } else {
                  controller.text = pickedTime.format(context);
                  if (onTimePicked != null) onTimePicked(pickedTime);
                }
              }
            }
          : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  TimeOfDay _parseTime(String time) {
    // Define a RegExp pattern to match the expected 'h:mm AM/PM' format
    final timePattern = RegExp(r'^(1[0-2]|0?[1-9]):([0-5][0-9])\s?(AM|PM)$',
        caseSensitive: false);

    // Check if the time matches the expected format
    if (timePattern.hasMatch(time.trim())) {
      // If valid, split the time into parts
      final parts = time.split(RegExp(r'[:\s]'));
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      String period = parts[2].toUpperCase();

      // Convert to 24-hour format if needed
      if (period == 'PM' && hour < 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return TimeOfDay(hour: hour, minute: minute);
    } else {
      throw FormatException(
          "Invalid time format. Please use 'h:mm AM/PM' format.");
    }
  }

  bool _isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    return (time1.hour < time2.hour) ||
        (time1.hour == time2.hour && time1.minute < time2.minute);
  }

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
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}
