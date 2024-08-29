const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const app = express();
const port = 3000;

// Initialize the SQLite database
const db = new sqlite3.Database('./database.db'); // Persists data in a file

// Create a table to track name submissions
db.serialize(() => {
  db.run("CREATE TABLE IF NOT EXISTS name_counts (name TEXT, count INTEGER)");
});

// Middleware to parse form data
app.use(express.urlencoded({ extended: true }));

// Serve the dynamic webpage
app.get('/', (req, res) => {
  res.send(`
    <h1>Welcome to My Dynamic Website</h1>
    <p>This content is served dynamically using Node.js and Express.</p>
    <form action="/submit" method="POST">
      <label for="name">Enter your name: </label>
      <input type="text" id="name" name="name" required>
      <button type="submit">Submit</button>
    </form>
  `);
});

// Handle form submission and track name submissions
app.post('/submit', (req, res) => {
  const { name } = req.body;

  // Check if the name already exists in the database
  db.get("SELECT count FROM name_counts WHERE name = ?", [name], (err, row) => {
    if (row) {
      // Update the count if the name exists
      db.run("UPDATE name_counts SET count = count + 1 WHERE name = ?", [name], (err) => {
        if (err) {
          return res.send("Error updating count.");
        }
        res.send(`<h1>Hello, ${name}! You have submitted your name ${row.count + 1} times!</h1>`);
      });
    } else {
      // Insert the new name with an initial count of 1
      db.run("INSERT INTO name_counts (name, count) VALUES (?, 1)", [name], (err) => {
        if (err) {
          return res.send("Error inserting name.");
        }
        res.send(`<h1>Hello, ${name}! This is your first time submitting your name.</h1>`);
      });
    }
  });
});

// Start the server
app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
