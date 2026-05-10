const express = require('express');
const router = express.Router();
const db = require('./db');

// giả lập user
const userId = 1;

// GET
router.get('/transactions', async (req, res) => {
  const { categoryId, month, year } = req.query;

  let query = `
    SELECT t.*, c.icon AS category_icon
    FROM transactions t
    LEFT JOIN categories c ON t.category_id = c.id
    WHERE t.user_id = ?
  `;

  let params = [userId];

  if (categoryId) {
    query += ' AND t.category_id = ?';
    params.push(categoryId);
  }

  // có month + year → lọc theo tháng
  if (month && year) {
    query += ' AND MONTH(t.date) = ? AND YEAR(t.date) = ?';
    params.push(month, year);
  }

  // chỉ có year → lọc theo năm
  else if (year) {
    query += ' AND YEAR(t.date) = ?';
    params.push(year);
  }

  // không có year → không thêm điều kiện gì (lấy tất cả)

  query += ' ORDER BY t.date DESC';

  const [rows] = await db.query(query, params);
  res.json(rows);
});

// POST
router.post('/transactions', async (req, res) => {
  const { id, title, amount, date, type, category_id } = req.body;

  await db.query(
    `INSERT INTO transactions
    (id, title, amount, date, type, category_id, user_id)
    VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [id, title, amount, date, type, category_id, userId]
  );

  res.json({ message: 'Added' });
});

// PUT
router.put('/transactions/:id', async (req, res) => {
  const { title, amount, date, type, category_id } = req.body;

  await db.query(
    `UPDATE transactions
     SET title=?, amount=?, date=?, type=?, category_id=?
     WHERE id=? AND user_id=?`,
    [title, amount, date, type, category_id, req.params.id, userId]
  );

  res.json({ message: 'Updated' });
});

// DELETE
router.delete('/transactions/:id', async (req, res) => {
  await db.query(
    'DELETE FROM transactions WHERE id=? AND user_id=?',
    [req.params.id, userId]
  );

  res.json({ message: 'Deleted' });
});

module.exports = router;