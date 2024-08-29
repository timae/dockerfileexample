const express = require('express');
const app = express();
const port = 8080;

// Serve a dynamic webpage
app.get('/', (req, res) => {
  res.send(`
    <h1>Welcome to My Dynamic Website with Caddy</h1>
    <p>This content is served dynamically using Node.js and Express, proxied by Caddy.</p>
    <form action="/submit" method="POST">
      <label for="name">Enter your name: </label>
      <input type="text" id="name" name="name" required>
      <button type="submit">Submit</button>
    </form>
  `);
});

// Handle form submission
app.post('/submit', express.urlencoded({ extended: true }), (req, res) => {
  const { name } = req.body;
  res.send(`<h1>Hello, ${name}! Thanks for visiting!</h1>`);
});

// Start the server
app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
