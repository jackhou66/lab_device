import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List rentalTransactions = [];
  List filteredTransactions = [];
  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = '';
  bool showCompletedOnly = false;

  @override
  void initState() {
    super.initState();
    fetchRentalHistory();
  }

  Future<void> fetchRentalHistory() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/rental_transaction'));

      if (response.statusCode == 200) {
        setState(() {
          rentalTransactions = json.decode(response.body);
          filteredTransactions = rentalTransactions;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load rental history: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching rental history: $e';
        isLoading = false;
      });
    }
  }

  // Filter the transactions based on the search query and completed status
  void filterTransactions() {
    setState(() {
      filteredTransactions = rentalTransactions
          .where((transaction) {
        final matchesSearchQuery = transaction['transaction_id'].toString().contains(searchQuery) ||
            transaction['student_id'].toString().contains(searchQuery);
        final matchesStatus = showCompletedOnly ? transaction['status'] == 'completed' : true;
        return matchesSearchQuery && matchesStatus;
      })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
                filterTransactions();
              },
              decoration: InputDecoration(
                labelText: 'Search by Transaction ID or Student ID',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            // Completed Only Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Show Completed Only'),
                Switch(
                  value: showCompletedOnly,
                  onChanged: (bool value) {
                    setState(() {
                      showCompletedOnly = value;
                    });
                    filterTransactions();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Rental History Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Transaction ID')),
                    DataColumn(label: Text('Student ID')),
                    DataColumn(label: Text('Device ID')),
                    DataColumn(label: Text('Rental Date')),
                    DataColumn(label: Text('Return Date')),
                    DataColumn(label: Text('Due Date')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Rental Fee')),
                  ],
                  rows: filteredTransactions.map<DataRow>((transaction) {
                    return DataRow(
                      cells: [
                        DataCell(Text(transaction['transaction_id'].toString())),
                        DataCell(Text(transaction['student_id'].toString())),
                        DataCell(Text(transaction['device_id'].toString())),
                        DataCell(Text(transaction['rental_date'])),
                        DataCell(Text(transaction['return_date'])),
                        DataCell(Text(transaction['due_date'])),
                        DataCell(Text(transaction['status'])),
                        DataCell(Text(transaction['rental_fee'].toString())),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
