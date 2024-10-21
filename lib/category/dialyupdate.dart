import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:stayez/color.dart';
import 'package:stayez/database/allDatabase.dart';

class Update extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<Update> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await dbHelper.loadData();
    setState(() {
      _data = data;
    });
  }

  void _openImageFullScreen(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(imagePath: imagePath),
      ),
    );
  }

  void _openDocument(String documentPath) {
    OpenFile.open(
        documentPath); // Use this method to open documents with native apps
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
                'Daily Update',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: _data.isEmpty
            ? Center(child: Text('No data available'))
            : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  final item = _data[index];
                  return Card(
                    color: accentColor,
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Instructions: ${item['instruction']}'),
                          if (item['imagePath'] != null &&
                              File(item['imagePath']).existsSync())
                            GestureDetector(
                              onTap: () => _openImageFullScreen(context,
                                  item['imagePath']), // Pass the context here
                              child: Image.file(File(item['imagePath']),
                                  height: 100),
                            ),
                          if (item['documentPath'] != null)
                            ListTile(
                              title: Text(
                                  'Document: ${basename(item['documentPath'])}'),
                              onTap: () => _openDocument(item['documentPath']),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imagePath;

  FullScreenImagePage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image View'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
