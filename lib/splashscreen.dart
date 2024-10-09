import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayez/admin(login)/login.dart';
import 'package:stayez/adminDashboard/admindash.dart';
import 'package:stayez/color.dart';
import 'package:stayez/customnavigation.dart';
import 'package:stayez/student(login)/login.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool _isVisible = false;

  late SharedPreferences prefs;

  void _checkLoginStatus() async {
    prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      // If the user is already logged in, navigate to the HomePage
      bool isAdmin=prefs.getBool('isAdmin')??false;
      if(isAdmin){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdiminDash()),
        );
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationMenu()),
        );
      }

    }
  }

  @override
  void initState() {
    super.initState();
    // Trigger animation after a short delay
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _isVisible = true;
      });
    });
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            // App Name (Top slide down)
            AnimatedPositioned(
              top: _isVisible ? screenHeight * 0.45 : -100, // Slide from top
              left: 0,
              right: 0,
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              child: Center(
                child: Text(
                  "Stay EZ", // App name
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Slogan (Slide from side)
            AnimatedPositioned(
              top: screenHeight * 0.40,
              left: _isVisible ? 90 : -screenWidth, // Slide from left
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              child: Text(
                "Your Gateway to Success", // Slogan
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: black,
                ),
              ),
            ),

            // Buttons (Slide from bottom)
            AnimatedPositioned(
              bottom: _isVisible ? screenHeight * 0.20 : -100, // Slide from bottom
              left: 0,
              right: 0,
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor, // Button color
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Admin Login",
                      style: TextStyle(fontSize: 26,color: black),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBlue, // Button color
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Student Login",
                      style: TextStyle(fontSize: 20,color: black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}
