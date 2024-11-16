const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();

// Enable CORS for cross-origin requests
app.use(cors());
app.use(bodyParser.json());

// Database connection
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '12345678',
  database: 'a_rent_database_jiancai',
});

db.connect((err) => { 
  if (err) {
    console.error('Database connection failed:', err.message);
    process.exit(1); // Exit if connection fails
  }
  console.log('Connected to the database');
});

// Helper function to handle database queries
function executeQuery(query, params, res, successCallback) {
  db.query(query, params, (err, result) => {
    if (err) {
      console.error('Database error:', err.message);
      res.status(500).json({ error: 'Internal server error' });
    } else {
      successCallback(result);
    }
  });
}

// API: Get all devices
app.get('/devices', (req, res) => {
  const query = 'SELECT * FROM Device';
  executeQuery(query, [], res, (result) => {
    res.status(200).json(result);
  });
});

// API: Get all device categories
app.get('/device_categories', (req, res) => {
  const query = 'SELECT * FROM device_category';
  executeQuery(query, [], res, (result) => {
    res.status(200).json(result);
  });
});

// API: Add a student
app.post('/addStudent', (req, res) => {
  const { name, email, department, student_number } = req.body;

  // Validation
  if (!name || !student_number) {
    return res.status(400).json({ error: 'Name and student number are required' });
  }

  const query = 'INSERT INTO Student (name, email, department, student_number) VALUES (?, ?, ?, ?)';
  executeQuery(query, [name, email, department, student_number], res, (result) => {
    res.status(201).json({
      message: 'Student added successfully',
      student_id: result.insertId,
    });
  });
});

// API: Update a student's information
app.put('/updateStudent/:id', (req, res) => {
  const { id } = req.params;
  const { name, email, department, student_number } = req.body;

  const query =
    'UPDATE Student SET name = ?, email = ?, department = ?, student_number = ? WHERE student_id = ?';
  executeQuery(query, [name, email, department, student_number, id], res, (result) => {
    if (result.affectedRows === 0) {
      res.status(404).json({ error: 'Student not found' });
    } else {
      res.status(200).json({ message: 'Student updated successfully' });
    }
  });
});

// API: Delete a student
app.delete('/deleteStudent/:id', (req, res) => {
  const { id } = req.params;

  const query = 'DELETE FROM Student WHERE student_id = ?';
  executeQuery(query, [id], res, (result) => {
    if (result.affectedRows === 0) {
      res.status(404).json({ error: 'Student not found' });
    } else {
      res.status(200).json({ message: 'Student deleted successfully' });
    }
  });
});

// API: Get all students
app.get('/students', (req, res) => {
  const query = 'SELECT * FROM Student';
  executeQuery(query, [], res, (result) => {
    res.status(200).json(result);
  });
});

// API: Get a single student by ID
app.get('/student/:id', (req, res) => {
  const { id } = req.params;

  const query = 'SELECT * FROM Student WHERE student_id = ?';
  executeQuery(query, [id], res, (result) => {
    if (result.length === 0) {
      res.status(404).json({ error: 'Student not found' });
    } else {
      res.status(200).json(result[0]);
    }
  });
});

// API: Update a device status
app.put('/updateDevice/:id', (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  if (!status) {
    return res.status(400).json({ error: 'Status is required' });
  }

  const query = 'UPDATE Device SET status = ? WHERE device_id = ?';
  executeQuery(query, [status, id], res, (result) => {
    if (result.affectedRows === 0) {
      res.status(404).json({ error: 'Device not found' });
    } else {
      res.status(200).json({ message: 'Device status updated successfully' });
    }
  });
});

// API: Get devices by status
app.get('/devices/:status', (req, res) => {
  const { status } = req.params;

  const query = 'SELECT * FROM Device WHERE status = ?';
  executeQuery(query, [status], res, (result) => {
    res.status(200).json(result);
  });
});


// API: Get all rental transactions
app.get('/rental_transaction', (req, res) => {
  const query = 'SELECT * FROM rental_transaction';
  executeQuery(query, [], res, (result) => {
    res.status(200).json(result);
  });
});

// API: Add a new rental transaction
app.post('/addRentalTransaction', (req, res) => {
  const { transaction_id, student_id, device_id, rental_date, return_date, due_date, status, rental_fee, Rental_Transactioncol } = req.body;

  // Validation
  if (!transaction_id || !student_id || !device_id || !rental_date || !return_date || !due_date || !status || rental_fee == null || Rental_Transactioncol == null) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  // Inserting the rental transaction into the database
  const query = `INSERT INTO rental_transaction (transaction_id, student_id, device_id, rental_date, return_date, due_date, status, rental_fee, Rental_Transactioncol)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;

  executeQuery(query, [transaction_id, student_id, device_id, rental_date, return_date, due_date, status, rental_fee, Rental_Transactioncol], res, (result) => {
    res.status(201).json({
      message: 'Rental transaction added successfully',
      transaction_id: result.insertId,
    });
  });
});

// API: Get all blog articles
app.get('/articles', (req, res) => {
  const query = 'SELECT * FROM articles';
  executeQuery(query, [], res, (result) => {
    res.status(200).json(result);
  });
});
const bcrypt = require('bcryptjs');
// API: Create a new account
app.post('/createAccount', async (req, res) => {
  const { student_id,name, email, department, password } = req.body;

  // Validate input fields
  const bcrypt = require('bcryptjs');
  if (!name || !email || !password || !student_id) {
    return res.status(400).json({ error: 'Name, email, student number, and password are required' });
  }

  // Hash the password using bcrypt
  try {
    const hashedPassword = await bcrypt.hash(password, 12);

    // Insert the new user into the database
    const query = `INSERT INTO student (student_id,name, email, department,  password_hash)
                   VALUES (?, ?, ?, ?, ?)`;

    executeQuery(query, [student_id,name, email, department, hashedPassword], res, (result) => {
      res.status(201).json({
        message: 'Account created successfully',
        student_id: result.insertId,
      });
    });
  } catch (error) {
    console.error('Error hashing password:', error.message);
    res.status(500).json({ error: 'Failed to create account' });
  }
});

app.post('/insertDefaultStudents', (req, res) => {
  const students = req.body;
  
  students.forEach(async (student) => {
    try {
      // Check if student already exists
      const checkQuery = 'SELECT * FROM student WHERE student_id = ?';
      db.query(checkQuery, [student.student_id], (err, result) => {
        if (result.length === 0) {
          // Insert new student
          const query = 'INSERT INTO student (student_id, name, email, department, password_hash) VALUES (?, ?, ?, ?, ?)';
          db.query(query, [student.student_id, student.name, student.email, student.department, student.password_hash], (err, result) => {
            if (err) {
              console.error('Error inserting student: ' + err.stack);
            }
          });
        }
      });
    } catch (error) {
      console.error('Error handling insert: ' + error);
    }
  });
  res.status(200).send('Default students inserted');
});


// Mock function to query the database for a user by username
async function mockDatabaseQuery(username) {
  return new Promise((resolve, reject) => {
    const query = 'SELECT * FROM student WHERE student_id = ?';
    db.query(query, [username], (err, result) => {
      if (err) {
        reject(err);
      } else {
        resolve(result[0]);  // Return the first result
      }
    });
  });
}

// API: Login
app.post('/login', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).send('Missing username or password');
  }

  try {
    const query = 'SELECT * FROM student WHERE student_id = ?';
    db.query(query, [username], async (err, result) => {
      if (err) {
        console.error('Database error:', err.message);
        return res.status(500).send('Server error');
      }

      if (result.length === 0) {
        return res.status(404).send('User not found');
      }

      const user = result[0];
      const match = await bcrypt.compare(password, user.password_hash);

      if (match) {
        return res.status(200).send('Login successful');
      } else {
        return res.status(401).send('Invalid credentials');
      }
    });
  } catch (error) {
    console.error('Error during login:', error);
    return res.status(500).send('Server error');
  }
});


app.get('/user/:id', (req, res) => {
  const studentId = req.params.id; // Extract the ID from the request parameter

  const query = 'SELECT * FROM student WHERE student_id = ?';

  db.query(query, [studentId], (err, result) => {
    if (err) {
      console.error('Database error:', err.message);
      return res.status(500).send('Server error');
    }

    if (result.length === 0) {
      return res.status(404).send('User not found');
    }

    const user = result[0];
    res.status(200).json({
      id: user.student_id,
      name: user.name,
      email: user.email,
      department: user.department,
    });
  });
});

app.get('/orders', (req, res) => {
  const query = 'SELECT * FROM rental_transaction';
  executeQuery(query, [], res, (results) => {
    res.status(200).json(results);
  });
});


// Start the server
app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
