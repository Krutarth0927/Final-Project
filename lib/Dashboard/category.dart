import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayez/Dashboard/roomBooking.dart';
import 'package:stayez/admin(login)/login.dart';
import 'package:stayez/category/Emergency.dart';
import 'package:stayez/category/Servicesstudent.dart';
import 'package:stayez/category/complint.dart';
import 'package:stayez/category/dialyupdate.dart';
import 'package:stayez/category/fees.dart';
import 'package:stayez/category/register_form.dart';
import 'package:stayez/category/rules.dart';
import 'package:stayez/category/staffmember.dart';
import 'package:stayez/splashscreen.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  // List<Room> rooms = [];

  void onCategoryClick(BuildContext context, Widget? page) {
    if (page != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': Image.asset(
          'assets/playscreen/report.png',
          height: 40,
          width: 40,
        ),
        'label': 'Complaint Box',
        'page': ComplaintBoxScreen(),
      },
      {
        'icon': const Icon(Icons.login, size: 40, color: Colors.black),
        'label': 'Student Logout',
        'page': null, // Page is null to trigger custom method
        'action': () => _logout(context), // Custom method to be called on tap
      },
      {
        'icon': const Icon(Icons.schedule, size: 40, color: Colors.black),
        'label': 'Daily Register',
        'page': DailyRegisterForm(),
      },
      {
        'icon': const Icon(Icons.payments, size: 40, color: Colors.black),
        'label': 'Fees Payments',
        'page': StudentDisplayPhotoPage(), // Restricted by login
      },
      {
        'icon': const Icon(Icons.meeting_room, size: 40, color: Colors.black),
        'label': 'Room Booking',
        'page': StudentPage() // Restricted by login
      },
      {
        'icon': const Icon(Icons.group, size: 40, color: Colors.black),
        'label': 'Staff Member',
        'page': StaffPage(),
      },
      {
        'icon': const Icon(Icons.rule, size: 40, color: Colors.black),
        'label': 'Rules',
        'page': HostelRulesPage(),
      },
      {
        'icon': const Icon(Icons.update, size: 40, color: Colors.black),
        'label': 'Daily Update',
        'page': Update(),
      },
      {
        'icon': const Icon(Icons.miscellaneous_services,
            size: 40, color: Colors.black),
        'label': 'Services',
        'page': servicespro() // Restricted by login
      },
      {
        'icon': Image.asset(
          'assets/playscreen/administrator.png',
          height: 40,
          width: 40,
        ),
        'label': 'Admin',
        'page': Login(),
      },
      {
        'icon': Image.asset(
          'assets/playscreen/bell.png',
          height: 40,
          width: 40,
        ),
        'label': 'Emergency Bell',
        'page': EmergencyBellPage(),
      },
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE7E8D1),
        body: Column(
          children: [
            // Header with gradient background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Color(0xFFA7BEAE)),
              child: const Center(
                child: Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Grid view for categories
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 10, left: 20, right: 20),
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Three items per row
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio:
                        0.80, // Decreased aspect ratio to make cards taller
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return InkWell(
                      onTap: () {
                        if (item['action'] != null) {
                          item['action'](); // Trigger custom method
                        } else {
                          final page = item['page'];
                          if (page != null) {
                            onCategoryClick(context, page);
                          } else {
                            // Optionally show a login alert or message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login required')),
                            );
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFA7BEAE),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            item['icon'], // Icon of the item
                            const SizedBox(height: 10),
                            Text(
                              item['label'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  SharedPreferences prefs1 = await SharedPreferences.getInstance();

  prefs1.setBool('isLoggedIn', false);
  prefs1.setBool('isAdmin', false);
  prefs1.setString('userId', ""); // Store userId as a String

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => SplashScreen()), // Navigate to SplashScreen
  );
}
