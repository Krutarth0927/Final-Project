import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayez/Dashboard/category.dart';
import 'package:stayez/Dashboard/roomBooking.dart';
import 'package:stayez/category/dialyupdate.dart';
import 'package:stayez/category/register_form.dart';
import 'package:stayez/category/rules.dart';
import 'package:stayez/color.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key });

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  String? fullName;

  @override
  void initState() {
    super.initState();
    _loadStudentName();
  }

  // Load the student's name from SharedPreferences
  void _loadStudentName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? 'fullName'; // Default name if null
    });
  }

  String selectedWeek = "Mon";
  final List<String> weeks = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  final Map<String, List<Map<String, String>>> weekTasks = {
    "Mon": [
      {"day": "Mon", "taskName": "Breakfast", "Menu": "Pancakes, Eggs, Juice"},
      {"day": "Mon", "taskName": "Lunch", "Menu": "Salad, Chicken, Rice"},
      {"day": "Mon", "taskName": "Dinner", "Menu": "Pasta, Salad, Bread"},
    ],
    "Tue": [
      {"day": "Tue", "taskName": "Breakfast", "Menu": "Oatmeal, Fruit, Coffee"},
      {"day": "Tue", "taskName": "Lunch", "Menu": "Burger, Fries, Soda"},
      {"day": "Tue", "taskName": "Dinner", "Menu": "Pizza, Wings, Coke"},
    ],

    "Wed": [
      {"day": "Mon", "taskName": "Morning Jog", "Menu": "abcd "},
      {"day": "Tue", "taskName": "Grocery Shopping", "Menu": "abcd "},
      {"day": "Mon", "taskName": "Dinner", "Menu": "Pasta, Salad, Bread"},
    ],

    "Thu": [
      {"day": "Mon", "taskName": "Morning Jog", "Menu": "abcd "},
      {"day": "Tue", "taskName": "Grocery Shopping", "Menu": "abcd "},
      {"day": "Mon", "taskName": "Dinner", "Menu": "Pasta, Salad, Bread"},
    ],

    "Fri": [
      {"day": "Mon", "taskName": "Morning Jog", "Menu": "abcd "},
      {"day": "Tue", "taskName": "Grocery Shopping", "Menu": "abcd "},
      {"day": "Mon", "taskName": "Dinner", "Menu": "Pasta, Salad, Bread"},
    ],

    "Sat": [
      {"day": "Mon", "taskName": "Morning Jog", "Menu": "abcd "},
      {"day": "Tue", "taskName": "Grocery Shopping", "Menu": "abcd "},
      {"day": "Mon", "taskName": "Dinner", "Menu": "Pasta, Salad, Bread"},
    ],

    "Sun": [
      {"day": "Mon", "taskName": "Morning Jog", "Menu": "abcd "},
      {"day": "Tue", "taskName": "Grocery Shopping", "Menu": "abcd "},
      {"day": "Mon", "taskName": "Dinner", "Menu": "Pasta, Salad, Bread"},
    ],

    // (Other days are omitted for brevity)
  };

  final List<String> imgList = [
    'assets/slider/1.png',
    'assets/slider/2.png',
    'assets/slider/3.png',
    'assets/slider/4.png',
    'assets/slider/5.png',
  ];



  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope (
      onWillPop: () async{
        _exitApp(context); // Custom method to show exit confirmation dialog
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: accentColor,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Stay EZ',
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Text(
                  'Welcome, $fullName',
                  style: TextStyle(
                    fontSize: 20,
                    color: black,fontWeight: FontWeight.bold
                  ),
                ),
                // Image Slider
                CarouselSlider(
                  items: imgList
                      .map((item) => Container(
                    child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset(
                            item,
                            fit: BoxFit.cover,
                            width: 1000,
                            height: 500,
                          ),
                        )),
                  ))
                      .toList(),
                  carouselController: _controller,
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),

                // Dropdown and Task List
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select Day:",
                          style: TextStyle(fontSize: 18),
                        ),
                        Container(
                          child: DropdownButton<String>(
                            value: selectedWeek,
                            items: weeks.map((String week) {
                              return DropdownMenuItem<String>(
                                value: week,
                                child: Text(week),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedWeek = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
                    itemCount: weekTasks[selectedWeek]!.length,
                    itemBuilder: (context, index) {
                      var task = weekTasks[selectedWeek]![index];
                      return TaskCard(
                        day: task["day"]!,
                        taskName: task["taskName"]!,
                        Menu: task["Menu"]!,
                        color: index % 3 == 0
                            ? Colors.deepPurple.shade200
                            : index % 3 == 1
                            ? Colors.lightBlueAccent.shade100
                            : Colors.red.shade200,
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCardView(
                                context, Icons.rule, accentColor, HostelRulesPage()),
                            _buildCardView(
                                context, Icons.update, accentColor, Update()),
                            _buildCardView(context, Icons.door_back_door,
                                accentColor, StudentPage()),
                            _buildCardView(context, Icons.timelapse, accentColor,
                                DailyRegisterForm()),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Category",
                            style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 300),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Category()),
                            );
                          },
                          child: Text(
                            "See All",
                            style: TextStyle(fontSize: 15, color: black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildCardView(
      BuildContext context, IconData icon, Color color, Widget pageToNavigate) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pageToNavigate),
        );
      },
      child: Card(
        color: color,
        child: Padding(
          padding:
          const EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 30,
                color: black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exitApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you really want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancel exit
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Exit the app
              exit(0);

            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}


class TaskCard extends StatelessWidget {
  final String day;
  final String taskName;
  final String Menu;
  final Color color;

  TaskCard({
    required this.day,
    required this.taskName,
    required this.Menu,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(day),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Menu,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
