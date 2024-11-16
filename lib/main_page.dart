import 'package:flutter/material.dart';
import 'user_info_page.dart';
import 'blog_page.dart';
import 'device_category_page.dart';  // Add import for DeviceCategoryPage
import 'history_page.dart';  // Add import for HistoryPage

class MainPage extends StatelessWidget {
  final String username;  // Add a final variable to hold the username

  MainPage({Key? key, required this.username}) : super(key: key);  // Constructor to accept the username

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IoT Platform'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: const Text(
                'IoT Devices Borrow Platform',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('User Info'),
              onTap: () {
                // Navigate to UserInfoPage with the username
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfoPage(username: username),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Blog Page'),
              onTap: () {
                // Navigate to BlogPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlogPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Device Category'),
              onTap: () {
                // Navigate to DeviceCategoryPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeviceCategoryPage()),
                );
              },
            ),
            ListTile(
              title: const Text('History'),
              onTap: () {
                // Navigate to HistoryPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Welcome, $username!')),  // Display the username here
    );
  }
}
