import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayez/adminDashboard/admindash.dart';
import 'package:stayez/color.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool isVisible = false;
  bool isLoginTrue = false;

  // Hardcoded username and password
  final String correctUsername = 'admin';
  final String correctPassword = 'admin123';

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if the user is already logged in
  void _checkLoginStatus() async {
    prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isAdmin') ?? false;
    if (isLoggedIn) {
      // If the user is already logged in, navigate to the HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdiminDash()),
      );
    }
  }
  login() async {
    if (username.text == correctUsername && password.text == correctPassword) {
      if (!mounted) return;
      SharedPreferences prefs1 = await SharedPreferences.getInstance();

      prefs1.setBool('isLoggedIn', true);
      prefs1.setBool('isAdmin', true);


      Navigator.push(
         context, MaterialPageRoute(builder: (context) => AdiminDash()));
    } else {
      // If credentials are incorrect, set state to show error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(50)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/playscreen/welcomelogin.png", // Replace with your image asset path
                          height: 150,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Login to your account',
                          style: TextStyle(
                            fontSize: 16,
                            color: black,
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: username,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'UserName is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'Username',
                            filled: true,
                            fillColor: white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                          obscureText: !isVisible,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Password',
                            filled: true,
                            fillColor: white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              login();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 50),
                            backgroundColor: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              color: black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        isLoginTrue
                            ? const Text(
                          "Username or password is incorrect",
                          style: TextStyle(color:accentColor),
                        )
                            : SizedBox(),
                      ],
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
