import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  // Define connection settings
  static final ConnectionSettings settings = ConnectionSettings(
    host: 'your-database-host', // e.g., '127.0.0.1' for local MySQL server
    port: 3306, // default MySQL port
    user: 'your-database-user', // e.g., 'root'
    password: 'your-database-password',
    db: 'mydb', // your database name
  );

  // Method to get a connection
  static Future<MySqlConnection> getConnection() async {
    return await MySqlConnection.connect(settings);
  }

  // Fetch all students
  static Future<List<Map<String, dynamic>>> getStudents() async {
    var conn = await getConnection();
    var results = await conn.query('SELECT * FROM Student');
    List<Map<String, dynamic>> students = [];
    for (var row in results) {
      students.add({
        'student_id': row['student_id'],
        'name': row['name'],
        'email': row['email'],
        'department': row['department'],
        'student_number': row['student_number'],
      });
    }
    await conn.close();
    return students;
  }

  // Insert a new student
  static Future<void> addStudent(String name, String email, String department, String studentNumber) async {
    var conn = await getConnection();
    await conn.query(
      'INSERT INTO Student (name, email, department, student_number) VALUES (?, ?, ?, ?)',
      [name, email, department, studentNumber],
    );
    await conn.close();
  }

  // Fetch all devices
  static Future<List<Map<String, dynamic>>> getDevices() async {
    var conn = await getConnection();
    var results = await conn.query('SELECT * FROM Device');
    List<Map<String, dynamic>> devices = [];
    for (var row in results) {
      devices.add({
        'device_id': row['device_id'],
        'name': row['name'],
        'type': row['type'],
        'brand': row['brand'],
        'model': row['model'],
        'serial_number': row['serial_number'],
        'condition': row['condition'],
        'status': row['status'],
        'category_id': row['category_id'],
      });
    }
    await conn.close();
    return devices;
  }

  // Insert a new device
  static Future<void> addDevice(String name, String type, String brand, String model, String serialNumber, String condition, String status, int categoryId) async {
    var conn = await getConnection();
    await conn.query(
      'INSERT INTO Device (name, type, brand, model, serial_number, condition, status, category_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [name, type, brand, model, serialNumber, condition, status, categoryId],
    );
    await conn.close();
  }

  // Fetch rental transactions
  static Future<List<Map<String, dynamic>>> getRentalTransactions() async {
    var conn = await getConnection();
    var results = await conn.query('SELECT * FROM `Rental Transaction`');
    List<Map<String, dynamic>> transactions = [];
    for (var row in results) {
      transactions.add({
        'transaction_id': row['transaction_id'],
        'student_id': row['student_id'],
        'device_id': row['device_id'],
        'rental_date': row['rental_date'],
        'return_date': row['return_date'],
        'due_date': row['due_date'],
        'status': row['status'],
        'rental_fee': row['rental_fee'],
      });
    }
    await conn.close();
    return transactions;
  }

  // Insert a new rental transaction
  static Future<void> addRentalTransaction(int studentId, int deviceId, String rentalDate, String returnDate, String dueDate, String status, String rentalFee) async {
    var conn = await getConnection();
    await conn.query(
      'INSERT INTO `Rental Transaction` (student_id, device_id, rental_date, return_date, due_date, status, rental_fee) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [studentId, deviceId, rentalDate, returnDate, dueDate, status, rentalFee],
    );
    await conn.close();
  }

  // Fetch penalty details
  static Future<List<Map<String, dynamic>>> getPenalties() async {
    var conn = await getConnection();
    var results = await conn.query('SELECT * FROM Penalty');
    List<Map<String, dynamic>> penalties = [];
    for (var row in results) {
      penalties.add({
        'penalty_id': row['penalty_id'],
        'transaction_id': row['transaction_id'],
        'amount': row['amount'],
        'reason': row['reason'],
        'date_imposed': row['date_imposed'],
        'paid_status': row['paid_status'],
      });
    }
    await conn.close();
    return penalties;
  }

  // Insert a new penalty
  static Future<void> addPenalty(int transactionId, double amount, String reason, String dateImposed, String paidStatus) async {
    var conn = await getConnection();
    await conn.query(
      'INSERT INTO Penalty (transaction_id, amount, reason, date_imposed, paid_status) VALUES (?, ?, ?, ?, ?)',
      [transactionId, amount, reason, dateImposed, paidStatus],
    );
    await conn.close();
  }
}
