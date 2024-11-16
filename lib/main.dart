import 'package:flutter/material.dart';
import 'order_page.dart';
import 'history_page.dart';
import 'login_page.dart'; // Import LoginPage
import 'device_category_page.dart'; // Import the DeviceCategoryPage
import 'blog_page.dart'; // Import the BlogPage
import 'create_account_page.dart'; // Import CreateAccountPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drawer Example',
      initialRoute: '/',  // Initial route to load first screen
      routes: {
        '/': (context) => MainPage(),
        '/login': (context) => LoginPage(),
        '/createAccount': (context) => CreateAccountPage(), // Route to CreateAccountPage
        '/deviceCategory': (context) => DeviceCategoryPage(),
        '/history': (context) => HistoryPage(),
        '/blog': (context) => BlogPage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  final List selectedCategories = [
    {'category_name': 'Category 1'},
    {'category_name': 'Category 2'},
    {'category_name': 'Category 3'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Lab Devices Borrow Platform',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Login Page'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            ListTile(
              title: Text('Device Category'),
              onTap: () {
                Navigator.pushNamed(context, '/deviceCategory');
              },
            ),
            ListTile(
              title: Text('My Order List'),
              onTap: () {
                Navigator.pushNamed(context, '/order', arguments: selectedCategories);
              },
            ),
            ListTile(
              title: Text('History List'),
              onTap: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
            ListTile(
              title: Text('Blog List'),
              onTap: () {
                Navigator.pushNamed(context, '/blog');
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Main Page Content')),
    );
  }
}
