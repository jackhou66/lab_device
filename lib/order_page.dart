import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math'; // Import the Random class
import 'OrderListPage.dart';

final random = Random();
final transactionId = random.nextInt(1000000); // Generates a random integer < 1,000,000


class OrderPage extends StatefulWidget {
  final List selectedCategories;

  OrderPage({required this.selectedCategories});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _studentIdController = TextEditingController();
  final _deviceIdController = TextEditingController();
  final _rentalDateController = TextEditingController();
  final _returnDateController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _stateController = TextEditingController();
  final _rentalFeeController = TextEditingController();
  final _transactionColController = TextEditingController();

  // Send order data to the Node.js server
  Future<void> _placeOrder() async {
    final studentId = _studentIdController.text;
    final deviceId = _deviceIdController.text;
    final rentalDate = _rentalDateController.text;
    final returnDate = _returnDateController.text;
    final dueDate = _dueDateController.text;
    final state = _stateController.text;
    final rentalFee = _rentalFeeController.text;
    final transactionCol = double.tryParse(_transactionColController.text) ?? 0.0;

    // Validate that all fields are filled
    if (studentId.isEmpty || deviceId.isEmpty || rentalDate.isEmpty || returnDate.isEmpty || dueDate.isEmpty || state.isEmpty || rentalFee.isEmpty || transactionCol == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    // Validate that deviceId is a valid integer
    if (int.tryParse(deviceId) == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid device ID')));
      return;
    }

    // Generate a random transaction ID
    final transactionId = Random().nextInt(1000000);

    final url = Uri.parse('http://localhost:3000/addRentalTransaction');

    //String rentalDate = '2024-11-16';  // Example of correct format
    //String returnDate = '2024-11-20';
    //String dueDate = '2024-11-30';

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'transaction_id': transactionId,
        'student_id': studentId,
        'device_id': int.parse(deviceId),
        'rental_date': rentalDate,  // Ensure this is in YYYY-MM-DD format
        'return_date': returnDate,
        'due_date': dueDate,
        'status': 'ongoing',
        'rental_fee': rentalFee,
        'Rental_Transactioncol': transactionCol,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(labelText: 'Student ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _deviceIdController,
              decoration: InputDecoration(labelText: 'Device ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _rentalDateController,
              decoration: InputDecoration(labelText: 'Rental Date(ex:2024-11-20)'),
            ),
            TextField(
              controller: _returnDateController,
              decoration: InputDecoration(labelText: 'Return Date(ex:2024-11-20)'),
            ),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(labelText: 'Due Date(ex:2024-11-20)'),
            ),
            TextField(
              controller: _stateController,
              decoration: InputDecoration(labelText: 'status(ongoing/completed/overdue)'),
            ),
            TextField(
              controller: _rentalFeeController,
              decoration: InputDecoration(labelText: 'Rental Fee'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _transactionColController,
              decoration: InputDecoration(labelText: 'Transaction Column Value'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _placeOrder,
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
