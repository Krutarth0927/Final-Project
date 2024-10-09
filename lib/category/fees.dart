import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stayez/color.dart'; // To retrieve the image

class StudentDisplayPhotoPage extends StatefulWidget {
  @override
  _StudentDisplayPhotoPageState createState() => _StudentDisplayPhotoPageState();
}

class _StudentDisplayPhotoPageState extends State<StudentDisplayPhotoPage> {
  File? _image; // To store the retrieved image

  @override
  void initState() {
    super.initState();
    _loadImage(); // Load the image when the page loads
  }

  // Function to load the saved image
  Future<void> _loadImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/uploaded_image.png'; // Path to the saved image
    final imageFile = File(path);

    if (await imageFile.exists()) {
      setState(() {
        _image = imageFile; // Set the image if it exists
      });
    } else {
      print('No image found at: $path');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: accentColor,
          title: Padding(
            padding: const EdgeInsets.only(right: 35.0),
            child: Center(
                child: Text('Fees Page',style: TextStyle(fontWeight: FontWeight.bold),)),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image != null
                  ? Image.file(_image!) // Display the uploaded image
                  : Text('No image available'),
            ],
          ),
        ),
      ),
    );
  }
}
