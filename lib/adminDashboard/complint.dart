import 'package:flutter/material.dart';
import 'package:stayez/color.dart';
import '../database/allDatabase.dart';

class AdminComplaintView extends StatefulWidget {
  @override
  _AdminComplaintViewState createState() => _AdminComplaintViewState();
}

class _AdminComplaintViewState extends State<AdminComplaintView> {
  late Future<List<Map<String, dynamic>>> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    _complaintsFuture = DatabaseHelper().getComplaints();
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
              'Complaint Box',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _complaintsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No complaints found.'));
              } else {
                final complaints = snapshot.data!;
                return ListView.builder(
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: accentColor,
                      margin: EdgeInsets.only(bottom: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Room No: ${complaints[index]['room_no']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Complaint Type: ${complaints[index]['complaint_type']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Details: ${complaints[index]['complaint_details']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
