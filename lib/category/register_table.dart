import 'package:flutter/material.dart';
import '../database/allDatabase.dart';
import 'package:stayez/color.dart';

class RegisterTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 35.0),
                child: Text(
                  "Register Entries",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
          backgroundColor: accentColor,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseHelper.instance.queryAllRegisters(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            'Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Room No',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Entry Date & Time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Exit Date & Time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Reason',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                        ),
                      ],
                      rows: snapshot.data!.map((row) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                row['name'],
                                style: TextStyle(
                                  color: black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                row['room_no'],
                                style: TextStyle(
                                  color: black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                row['entry_date_time'],
                                style: TextStyle(
                                  color: black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                row['exit_date_time'],
                                style: TextStyle(
                                  color: black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                row['reason'],
                                style: TextStyle(
                                  color: black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                          color: MaterialStateColor.resolveWith(
                                  (states) => states.contains(MaterialState.selected)
                                  ? black
                                  : trans
                          ),
                        );
                      }).toList(),
                      headingRowColor: MaterialStateColor.resolveWith(
                            (states) => accentColor,
                      ),
                      dataRowHeight: 60,
                      headingRowHeight: 70,
                      columnSpacing: 30,
                      horizontalMargin: 10,
                      dividerThickness: 1.5,
                      showBottomBorder: true,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
