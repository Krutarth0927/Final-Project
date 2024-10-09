import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:stayez/color.dart'; // Ensure this import matches your file structure

class servicespro extends StatefulWidget {
  const servicespro({super.key});

  @override
  State<servicespro> createState() => _servicespro();
}

class _servicespro extends State<servicespro> {
  late List<ServiceProvider> serviceProviders;

  Future<void> _loadServiceProviders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? serviceProviderJson = prefs.getString('serviceProviders');
    if (serviceProviderJson != null) {
      final List<dynamic> decoded = jsonDecode(serviceProviderJson);
      setState(() {
        serviceProviders = decoded.map((service) => ServiceProvider.fromJson(service)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadServiceProviders();
  }

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
              child: Padding(
                padding: const EdgeInsets.only(right: 35.0),
                child: Text(
                  "Service Providers",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
        ),
        body: ListView.builder(
          itemCount: serviceProviders.length,
          itemBuilder: (context, index) {
            final service = serviceProviders[index];
            return SizedBox(
              height: 120,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: accentColor,
                  child: ListTile(
                    title: Text("Name: ${service.name}"),
                    subtitle: Text("Role: ${service.role}\nPhone: ${service.phone}",style: TextStyle(color: black,fontSize: 20,fontWeight: FontWeight.bold),),
                    onTap: () => _launchPhone(service.phone), // Make phone number clickable
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ServiceProvider {
  final int id;
  String name;
  String role;
  String phone;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'phone': phone,
    };
  }
}
