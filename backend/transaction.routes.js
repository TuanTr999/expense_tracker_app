const express = require('express');
const router = express.Router();
const db = require('./db');

// giả lập user
const userId = 1;

// GET BALANCE
router.get('/transactions/balance', async (req, res) => {
  const { day, month, year } = req.query;

  if (!year) {
    return res.status(400).json({
      message: 'year is required',
    });
  }

  const currentYear = Number(year);
  const currentMonth = month ? Number(month) : null;
  const currentDay = day ? Number(day) : null;

  try {
    // MODE 1: có day + month + year
    if (currentDay && currentMonth) {
      const [currentRows] = await db.query(
        `
        SELECT COALESCE(SUM(
          CASE
            WHEN type = 'income' THEN amount
            WHEN type = 'expense' THEN -amount
            ELSE 0
          END
        ), 0) AS balance
        FROM transactions
        WHERE user_id = ?
          AND DAY(date) = ?
          AND MONTH(date) = ?
          AND YEAR(date) = ?
        `,
        [userId, currentDay, currentMonth, currentYear]
      );

      const currentBalance = Number(currentRows[0].balance);

      return res.json({
        type: 'daily',
        day: currentDay,
        month: currentMonth,
        year: currentYear,
        currentBalance,
      });
    }

    // MODE 2: có month + year
    if (currentMonth) {
      let previousMonth = currentMonth - 1;
      let previousYear = currentYear;

      if (previousMonth === 0) {
        previousMonth = 12;
        previousYear = currentYear - 1;
      }

      const [currentRows] = await db.query(
        `
        SELECT COALESCE(SUM(
          CASE
            WHEN type = 'income' THEN amount
            WHEN type = 'expense' THEN -amount
            ELSE 0
          END
        ), 0) AS balance
        FROM transactions
        WHERE user_id = ?
          AND MONTH(date) = ?
          AND YEAR(date) = ?
        `,
        [userId, currentMonth, currentYear]
      );

      const [previousRows] = await db.query(
        `
        SELECT COALESCE(SUM(
          CASE
            WHEN type = 'income' THEN amount
            WHEN type = 'expense' THEN -amount
            ELSE 0
          END
        ), 0) AS balance
        FROM transactions
        WHERE user_id = ?
          AND MONTH(date) = ?
          AND YEAR(date) = ?
        `,
        [userId, previousMonth, previousYear]
      );

      const currentBalance = Number(currentRows[0].balance);
      const previousBalance = Number(previousRows[0].balance);

      return res.json({
        type: 'monthly',
        month: currentMonth,
        year: currentYear,
        previousMonth,
        previousYear,
        currentBalance,
        previousBalance,
        totalBalance: currentBalance + previousBalance,
      });
    }

    // MODE 3: chỉ có year
    const previousYear = currentYear - 1;

    const [currentRows] = await db.query(
      `
      SELECT COALESCE(SUM(
        CASE
          WHEN type = 'income' THEN amount
          WHEN type = 'expense' THEN -amount
          ELSE 0
        END
      ), 0) AS balance
      FROM transactions
      WHERE user_id = ?
        AND YEAR(date) = ?
      `,
      [userId, currentYear]
    );

    const [previousRows] = await db.query(
      `
      SELECT COALESCE(SUM(
        CASE
          WHEN type = 'income' THEN amount
          WHEN type = 'expense' THEN -amount
          ELSE 0
        END
      ), 0) AS balance
      FROM transactions
      WHERE user_id = ?
        AND YEAR(date) = ?
      `,
      [userId, previousYear]
    );

    const currentBalance = Number(currentRows[0].balance);
    const previousBalance = Number(previousRows[0].balance);

    return res.json({
      type: 'yearly',
      year: currentYear,
      previousYear,
      currentBalance,
      previousBalance,
      totalBalance: currentBalance + previousBalance,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: 'Failed to calculate balance',
    });
  }
});

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