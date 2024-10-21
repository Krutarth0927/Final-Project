// admin_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:stayez/color.dart';
import '../database/allDatabase.dart';
// Import the DatabaseHelper class

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _instructionController = TextEditingController();
  String? _imagePath;
  String? _documentPath;
  DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isLoading = false;
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _databaseHelper.loadData();
    setState(() {
      _data = data;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _documentPath = result.files.single.path;
      });
    }
  }

  Future<void> _saveData() async {
    if (_instructionController.text.isEmpty) {
      _showSimpleMessage(
          'Please fill all the fields and upload the required files.');
      return; // Don't save if any field is empty
    }

    await _databaseHelper.insertData(
      _instructionController.text,
      _imagePath,
      _documentPath,
    );
    _showSimpleMessage('Data saved successfully');
    _loadData(); // Refresh the data after saving
  }

  Future<void> _deleteData(int id) async {
    await _databaseHelper.deleteData(id);
    _showSimpleMessage('Data deleted successfully');
    _loadData(); // Refresh the data after deleting
  }

  void _showSimpleMessage(String message) {
    // showDialog(
    //   context: context,
    //builder:
    (BuildContext context) {
      return AlertDialog(
        title: Text('Message'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
      //   },
      // );
    };
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
              'Admin Add Instruction Page',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _instructionController,
                      decoration: InputDecoration(labelText: 'Instructions'),
                    ),
                    SizedBox(height: 16.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: Text(
                              'Upload Image',
                              style: TextStyle(color: black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _pickDocument,
                            child: Text(
                              'Upload Document',
                              style: TextStyle(color: black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _saveData,
                            child: Text('Save', style: TextStyle(color: black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_imagePath != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Image.file(File(_imagePath!), height: 100),
                      ),
                    SizedBox(height: 16.0),
                    if (_documentPath != null)
                      Text('Document: ${basename(_documentPath!)}'),
                    SizedBox(height: 16.0),
                    Divider(color: black, thickness: 2),
                    Expanded(
                      child: _data.isEmpty
                          ? Center(child: Text('No data available'))
                          : ListView.builder(
                              itemCount: _data.length,
                              itemBuilder: (context, index) {
                                final item = _data[index];
                                return Card(
                                  color: accentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  margin: EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Instructions: ${item['instruction']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        if (item['imagePath'] != null &&
                                            File(item['imagePath'])
                                                .existsSync())
                                          Image.file(File(item['imagePath']),
                                              height: 100),
                                        if (item['documentPath'] != null)
                                          Text(
                                              'Document: ${basename(item['documentPath'])}'),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            icon: Icon(Icons.delete,
                                                color: black),
                                            onPressed: () =>
                                                _deleteData(item['id']),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
