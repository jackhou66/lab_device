import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List rentalTransactions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRentalTransactions();
  }

  Future<void> fetchRentalTransactions() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/orders')); // Replace with the correct API URL for rental transactions

      if (response.statusCode == 200) {
        setState(() {
          rentalTransactions = List.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load rental transactions: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching rental transactions: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Transactions'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: rentalTransactions.length,
        itemBuilder: (context, index) {
          final transaction = rentalTransactions[index];
          return ListTile(
            title: Text('Transaction ID: ${transaction['transaction_id']}'),
            subtitle: Text('Device ID: ${transaction['device_id']} - Status: ${transaction['status']}'),
          );
        },
      ),
    );
  }
}
