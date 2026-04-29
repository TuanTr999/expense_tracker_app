const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '31012025',
  database: 'expense_app'
});

module.exports = pool;