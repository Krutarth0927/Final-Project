import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stayez/color.dart';
import '../database/allDatabase.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final dateController = TextEditingController();
  List<Map<String, dynamic>> records = [];

  void _fetchRecords() async {
    if (dateController.text.isNotEmpty) {
      String selectedDate =
          dateController.text; // The date selected by the user.
      List<Map<String, dynamic>> fetchedRecords =
          await DatabaseHelper.instance.queryRegisterByDate(selectedDate);
      setState(() {
        records = fetchedRecords;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      final String formattedDate =
          DateFormat('dd-MM-yyyy').format(selectedDate);
      dateController.text = formattedDate;
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 35),
            child: Text(
              "Register Detail",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
          backgroundColor: accentColor,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: "Select Date",
                  prefixIcon: Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                readOnly: true, // Prevent manual input
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchRecords,
                child: Text("Records"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: black,
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Index')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Room No')),
                        DataColumn(label: Text('Entry Time')),
                        DataColumn(label: Text('Exit Time')),
                        DataColumn(label: Text('Reason')),
                      ],
                      rows: List<DataRow>.generate(
                        records.length,
                        (index) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text('${index + 1}')), // Display index
                            DataCell(Text(records[index]['name'])),
                            DataCell(Text(records[index]['room_no'])),
                            DataCell(Text(records[index]['entry_date_time'])),
                            DataCell(Text(records[index]['exit_date_time'])),
                            DataCell(Text(records[index]['reason'])),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
