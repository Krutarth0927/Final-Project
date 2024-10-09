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

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController roomNoController = TextEditingController();
  DateTime? dob;
  String? address;
  String? collageName;
  String? nationality;
  String? religion;
  String? category;
  String? currentCourse;
  String? yearOfStudy;
  String? parentName;
  // String? roomNo;
  String? parentContactNo;

  final List<String> categories = ['General', 'OBC', 'SC', 'ST'];
  final List<String> courses = ['B.Sc', 'B.Tech', 'M.Sc', 'M.Tech'];
  final List<String> religions = ['Hindu', 'Muslim', 'Christian', 'Other'];

  @override
  void dispose() {
    fullNameController.dispose();
    super.dispose();
  }
  Future<void> _saveStudentName(String fullName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', fullName);
    // await prefs.setString('roomNo', roomNoController.text);
  //
  }


  void _saveForm() async {

      // String fullName = fullNameController.text;
      // _saveStudentName(fullName);
      // Navigator.pop(context); // Return to the homepage or navigate accordingly

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
        'parentName': parentName,
        'parentContactNo': parentContactNo,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Mobile no';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: roomNoController,
                  decoration: InputDecoration(
                    labelText: 'Room NO',
                    prefixIcon: Icon(Icons.room),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DailyRegisterForm(),
                      //   ),
                      // );
                      return 'Please enter your Room number';
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
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    yearOfStudy = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your year of study';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Parent's Name",
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    parentName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your parent\'s name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Parent's Contact Number",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    parentContactNo = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your parent\'s contact number';
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
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onSaved: (value) {
                    // Password is saved directly
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: Text('Register',style: TextStyle(color: black),),
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
