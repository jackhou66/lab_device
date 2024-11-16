import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TableListPage extends StatefulWidget {
  const TableListPage({Key? key}) : super(key: key);

  @override
  _TableListPageState createState() => _TableListPageState();
}

class _TableListPageState extends State<TableListPage> {
  List devices = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  // Fetch devices from the API
  Future<void> fetchDevices() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/devices'));

      if (response.statusCode == 200) {
        setState(() {
          devices = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load devices. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching devices: $e';
      });
    }
  }

  // Sorting columns
  bool isAscending = true;

  // Method to sort the list by a particular column
  void _sortDevices(int columnIndex, bool ascending) {
    setState(() {
      devices.sort((a, b) {
        int result = 0;
        if (columnIndex == 0) {
          result = a['id'].compareTo(b['id']);
        } else if (columnIndex == 1) {
          result = a['name'].compareTo(b['name']);
        } else if (columnIndex == 2) {
          result = a['status'].compareTo(b['status']);
        }
        return ascending ? result : -result;
      });
      isAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Table/List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage))
            : SingleChildScrollView(
          child: DataTable(
            sortAscending: isAscending,
            sortColumnIndex: 0,  // Default column to sort
            columns: const [
              DataColumn(label: Text('Device ID')),
              DataColumn(label: Text('Device Name')),
              DataColumn(label: Text('Status')),
            ],
            rows: devices.map<DataRow>((device) {
              return DataRow(cells: [
                DataCell(Text(device['id'].toString())),
                DataCell(Text(device['name'])),
                DataCell(Text(device['status'])),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
