import 'package:flutter/material.dart';
import 'package:stayez/color.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyBellPage extends StatelessWidget {
  const EmergencyBellPage({Key? key}) : super(key: key);

  // Function to open the SMS app with the emergency message
  // void sendEmergencyMessage() async {
  //   const phoneNumber = '+919484776059'; // Replace with the warden/security number
  //   const emergencyMessage = 'Emergency alert from hostel app. Please respond immediately!';
  //   final smsUrl = 'sms:$phoneNumber?body=$emergencyMessage';
  //
  //   if (await canLaunch(smsUrl)) {
  //     await launch(smsUrl);
  //   } else {
  //     throw 'Could not launch $smsUrl';
  //   }
  // }

  // Function to open the dial pad with the given phone number
  void _makePhoneCall(String phoneNumber) async {
    final phoneUrl = 'tel:$phoneNumber';

    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw 'Could not launch $phoneUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 35),
              child: Text(
                'Emergency Bell',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          backgroundColor: redaccent,
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 56.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Emergency Bell Icon Button
              Icon(Icons.notifications,color:redaccent,size: 150,),
              SizedBox(height: 20),

              // Label and description
              Text(
                'Press the bell to send an emergency Call to hostel staff.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // Emergency contact info for warden and call button
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Warden:', style: TextStyle(fontSize: 20)),
                        GestureDetector(
                          onTap: () => _makePhoneCall('+919484776059'), // Warden's number
                          child: Text(
                            'Phone: +91 9484776059',
                            style: TextStyle(
                              fontSize: 24,
                              color: Blue,

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Emergency contact info for security and call button
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Security:', style: TextStyle(fontSize: 20)),
                        GestureDetector(
                          onTap: () => _makePhoneCall('+919876543210'), // Security's number
                          child: Text(
                            'Phone: +91 9876543210',
                            style: TextStyle(
                              fontSize: 24,
                              color: Blue,

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
