import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stayez/color.dart';

import '../database/allDatabase.dart'; // Custom colors

class AdminSendPhotoPage extends StatefulWidget {
  @override
  _AdminSendPhotoPageState createState() => _AdminSendPhotoPageState();
}

class _AdminSendPhotoPageState extends State<AdminSendPhotoPage> {
  File? _image; // To store the selected image
  final ImagePicker _picker = ImagePicker();
  bool _isImageUploaded = false; // To track if the image has been uploaded

  @override
  void initState() {
    super.initState();
    _loadSavedImage(); // Load the saved image on page load
  }

  // Pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isImageUploaded = false; // Reset the flag since a new image is picked
      });
    }
  }

  // Function to save the image locally and update database
  Future<void> _saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/uploaded_image.png';
    await image.copy(path);

    // Insert or update the image path in the database
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'image_uploads',
      {
        'file_path': path,
        'upload_date': DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    setState(() {
      _isImageUploaded = true;
    });

    print('Image saved at: $path');
  }

  // Function to delete the image
  Future<void> _deleteImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/uploaded_image.png';
    final imageFile = File(path);

    if (await imageFile.exists()) {
      await imageFile.delete(); // Delete the image file from storage

      // Remove the record from the database
      final db = await DatabaseHelper.instance.database;
      await db.delete(
        'image_uploads',
        where: 'file_path = ?',
        whereArgs: [path],
      );

      setState(() {
        _image = null; // Reset the image display
        _isImageUploaded = false; // Reset upload flag
      });

      print('Image and its database record deleted from: $path');
    }
  }

  // Load the saved image from local storage if it exists
  Future<void> _loadSavedImage() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('image_uploads', limit: 1);

    if (result.isNotEmpty) {
      final String? savedPath = result.first['file_path'] as String?;
      if (savedPath != null && File(savedPath).existsSync()) {
        setState(() {
          _image = File(savedPath);
          _isImageUploaded = true; // Mark as uploaded since it exists
        });
      }
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
              child: Text('Admin - Upload QR Code',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _image != null
                    ? Column(
                        children: [
                          Image.file(_image!), // Display the selected image
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _deleteImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .red, // Background color for delete button
                            ),
                            child: Text('Delete Image',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      )
                    : Text('No image selected',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor, // Background color
                  ),
                  child: Text('Pick Image', style: TextStyle(color: black)),
                ),
                SizedBox(height: 20),
                // Only show OK button when an image is selected
                _image != null
                    ? ElevatedButton(
                        onPressed: () {
                          _saveImage(
                              _image!); // Save the image when OK is pressed
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor, // Background color
                        ),
                        child: Text(_isImageUploaded ? 'Photo Sent' : 'OK',
                            style: TextStyle(color: black)),
                      )
                    : Container(),
                SizedBox(height: 20),
                // Message to confirm if the photo has been uploaded
                _isImageUploaded
                    ? Text(
                        'Photo has been sent successfully!',
                        style: TextStyle(color: black, fontSize: 20),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
