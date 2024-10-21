import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayez/category/register_form.dart';
import 'package:stayez/color.dart';
import 'package:stayez/student(login)/login.dart';

import '../database/allDatabase.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController roomNoController = TextEditingController();
  final TextEditingController parentsocntact = TextEditingController();
  final TextEditingController parentsname = TextEditingController();
  DateTime? dob;
  String? address;
  String? collageName;
  String? nationality;
  String? religion;
  String? category;
  String? currentCourse;
  String? yearOfStudy;

  // String? roomNo;

  final List<String> categories = ['General', 'OBC', 'SC', 'ST'];
  final List<String> courses = ['B.Sc', 'B.Tech', 'M.Sc', 'M.Tech'];
  final List<String> religions = ['Hindu', 'Muslim', 'Christian', 'Other'];

  @override
  void dispose() {
    super.dispose();

  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('roomNo', roomNoController.text);
    // Navigate to SecondPage after saving
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DailyRegisterForm()),
    );
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, dynamic> user = {
        'fullName': fullNameController.text,
        'dob': dob?.toIso8601String(),
        'mobileNo': mobileNoController.text,
        'address': address,
        'collageName': collageName,
        'currentCourse': currentCourse,
        'yearOfStudy': yearOfStudy,
        'parentName': parentsname.text,
        'parentContactNo': parentsocntact.text,
        'password': passwordController.text,
        'roomNo': roomNoController.text,
      };

      DatabaseHelper db = DatabaseHelper();
      int userId = await db.saveUser(user); // Save and get the inserted ID
      print(userId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
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
              padding: const EdgeInsets.only(right: 35),
              child: Text(
                'Student Sign-Up',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 20, // Set the maximum number of characters to 20
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    // Check if the input contains more than 20 characters
                    if (value.length > 20 || value.length < 3) {
                      return 'Please enter no more than 20 characters and not \n less than 3';
                    }
                    // Check if the input contains only alphabetic characters (no spaces)
                    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return 'Please enter only alphabetical characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null && picked != dob) {
                      setState(() {
                        dob = picked;
                        dateController.text =
                            '${dob!.day}/${dob!.month}/${dob!.year}';
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      dob == null
                          ? 'Select Date of Birth'
                          : '${dob!.day}/${dob!.month}/${dob!.year}',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: mobileNoController,
                  decoration: InputDecoration(
                    labelText: 'Mobile No',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10, // Ensure only 10 digits can be entered
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Mobile no';
                    }
                    // Check if the input is exactly 10 digits and contains only numeric characters
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: roomNoController,
                  decoration: InputDecoration(
                    labelText: 'Room No',
                    prefixIcon: Icon(Icons.room),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      TextInputType.number, // Allows only numeric input
                  maxLength: 3, // Limit the input to 3 characters
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Room number';
                    }
                    // Check if the input contains exactly 3 digits and no special characters
                    if (!RegExp(r'^[0-9]{3}$').hasMatch(value)) {
                      return 'Please enter a valid 3-digit room number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    address = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'College Name',
                    prefixIcon: Icon(Icons.school),
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    collageName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your college name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Current Course',
                      border: OutlineInputBorder(),
                      //     icon: Icon(Icons.school), // Add your desired icon here
                    ),
                    items: courses.map((String course) {
                      return DropdownMenuItem<String>(
                        value: course,
                        child: Text(course),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        currentCourse = newValue;
                      });
                    },
                    onSaved: (value) {
                      currentCourse = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your current course';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Year of Study',
                    prefixIcon: Icon(Icons.timeline),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number, // Allows numeric input
                  onSaved: (value) {
                    yearOfStudy = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your year of study';
                    }
                    // Check if the input contains only numbers and the '-' symbol
                    if (!RegExp(r'^[0-9-]+$').hasMatch(value)) {
                      return 'Please enter a valid year using only numbers and "-" symbol';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: parentsname,
                  decoration: InputDecoration(
                    labelText: "Parent's Name",
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 20,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your parent\'s name';
                    }
                    if (value.length > 20 || value.length < 3) {
                      return 'Please enter no more than 20 characters and not less \n than 3';
                    }
                    // Check if the input contains only alphabetic characters (no spaces)
                    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return 'Please enter only alphabetical characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: parentsocntact,
                  decoration: InputDecoration(
                    labelText: "Parent's Contact Number",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your parent\'s contact number';
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                      border: OutlineInputBorder(),
                    ),
                    obscureText:
                        !_isPasswordVisible, // Hides the password input
                    onSaved: (value) {
                      // Password is saved directly
                    },
                    maxLength: 8,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      // Check if the input is exactly 8 characters long and contains only alphabetical characters
                      return null;
                    }),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: Text(
                    'Register',
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
