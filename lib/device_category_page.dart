import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'order_page.dart';
import 'dart:convert';

class DeviceCategoryPage extends StatefulWidget {
  @override
  _DeviceCategoryPageState createState() => _DeviceCategoryPageState();
}

class _DeviceCategoryPageState extends State<DeviceCategoryPage> {
  List deviceCategories = [];
  List selectedCategories = []; // List to store selected categories
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDeviceCategories();
  }

  Future<void> fetchDeviceCategories() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/device_categories'));

      if (response.statusCode == 200) {
        setState(() {
          deviceCategories = List.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load device categories: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching device categories: $e';
        isLoading = false;
      });
    }
  }

  void navigateToOrderPage() {
    if (selectedCategories.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPage(selectedCategories: selectedCategories),
        ),
      );
    } else {
      // Optionally show an alert if no categories are selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one category')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Categories'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: deviceCategories.length,
        itemBuilder: (context, index) {
          final category = deviceCategories[index];
          return CheckboxListTile(
            title: Text(category['category_name']),
            subtitle: Text('${category['category_id']} - ${category['description']}'),
            value: selectedCategories.contains(category),
            onChanged: (bool? selected) {
              setState(() {
                if (selected!) {
                  selectedCategories.add(category);
                } else {
                  selectedCategories.remove(category);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToOrderPage, // Navigate to the order page
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
