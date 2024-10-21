import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayez/category/Servicesstudent.dart';
import 'package:stayez/color.dart';

class AdminServiceProviderPage extends StatefulWidget {
  @override
  _AdminServiceProviderPageState createState() =>
      _AdminServiceProviderPageState();
}

class _AdminServiceProviderPageState extends State<AdminServiceProviderPage> {
  List<ServiceProvider> serviceProviders = [];

  @override
  void initState() {
    super.initState();
    _loadServiceProviders();
  }

  Future<void> _loadServiceProviders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? serviceProviderJson = prefs.getString('serviceProviders');
    if (serviceProviderJson != null) {
      final List<dynamic> decoded = jsonDecode(serviceProviderJson);
      setState(() {
        serviceProviders = decoded
            .map((service) => ServiceProvider.fromJson(service))
            .toList();
      });
    }
  }

  Future<void> _saveServiceProviders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> serviceProviderJson =
        serviceProviders.map((service) => service.toJson()).toList();
    await prefs.setString('serviceProviders', jsonEncode(serviceProviderJson));
  }

  void addServiceProvider(ServiceProvider service) {
    setState(() {
      serviceProviders.add(service);
      _saveServiceProviders();
    });
  }

  void updateServiceProvider(
      int serviceId, String newName, String newRole, String newPhone) {
    setState(() {
      final service = serviceProviders.firstWhere((s) => s.id == serviceId);
      service.name = newName;
      service.role = newRole;
      service.phone = newPhone;
      _saveServiceProviders();
    });
  }

  void deleteServiceProvider(int serviceId) {
    setState(() {
      serviceProviders.removeWhere((s) => s.id == serviceId);
      _saveServiceProviders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: accentColor,
          title: Center(
              child: Text(
            "Service Provider Management",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          actions: [
            IconButton(
              icon: Icon(
                Icons.people,
                color: black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => servicespro(),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: serviceProviders.length,
          itemBuilder: (context, index) {
            final service = serviceProviders[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: accentColor,
                child: ListTile(
                  title: Text("Name: ${service.name}"),
                  subtitle:
                      Text("Role: ${service.role} \nPhone: ${service.phone}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditServiceProviderPage(
                                service: service,
                                onServiceUpdated: updateServiceProvider,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: black,
                        ),
                        onPressed: () => deleteServiceProvider(service.id),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: buttonColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddServiceProviderPage(
                    onServiceAdded: addServiceProvider,
                    serviceProviders: serviceProviders),
              ),
            );
          },
          child: Icon(Icons.add, color: black),
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

class AddServiceProviderPage extends StatelessWidget {
  final Function(ServiceProvider) onServiceAdded;
  final List<ServiceProvider> serviceProviders;

  AddServiceProviderPage(
      {required this.onServiceAdded, required this.serviceProviders});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
              "Add Service Provider",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _roleController,
                decoration: InputDecoration(labelText: "Role"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final service = ServiceProvider(
                    id: serviceProviders.isNotEmpty
                        ? serviceProviders.last.id + 1
                        : 1, // Increment the ID based on existing service providers
                    name: _nameController.text,
                    role: _roleController.text,
                    phone: _phoneController.text,
                  );
                  onServiceAdded(service);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Add Service Provider",
                  style: TextStyle(color: black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditServiceProviderPage extends StatelessWidget {
  final ServiceProvider service;
  final Function(int, String, String, String) onServiceUpdated;

  EditServiceProviderPage(
      {required this.service, required this.onServiceUpdated});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = service.name;
    _roleController.text = service.role;
    _phoneController.text = service.phone;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: accentColor,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 35),
              child: Text(
                "Edit Service Provider",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _roleController,
                decoration: InputDecoration(labelText: "Role"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  onServiceUpdated(service.id, _nameController.text,
                      _roleController.text, _phoneController.text);
                  Navigator.of(context).pop();
                },
                child: Text("Update Service Provider",
                    style: TextStyle(color: black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
