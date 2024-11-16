import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserInfoPage extends StatefulWidget {
  final String username;

  UserInfoPage({Key? key, required this.username}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool isLoading = true;
  String? email;
  String? department;

  @override
  void initState() {
    super.initState();
    // Fetch user information from the server when the page is initialized
    _fetchUserInfo();
  }

  // Fetch user details from the server
  Future<void> _fetchUserInfo() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/user/${widget.username}'));

      if (response.statusCode == 200) {
        // Parse the response if the request is successful
        final data = jsonDecode(response.body);
        setState(() {
          email = data['email'];
          department = data['department'];
          isLoading = false;
        });
      } else {
        // Handle error if the user is not found
        setState(() {
          isLoading = false;
        });
        // Optionally show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())  // Show a loading spinner
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'User: ${widget.username}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (email != null)
              Text('Email: $email'),  // Display email from the response
            if (department != null)
              Text('Department: $department'),  // Display department from the response
            const SizedBox(height: 20),
            // Do not display the phone number here
          ],
        ),
      ),
    );
  }
}
