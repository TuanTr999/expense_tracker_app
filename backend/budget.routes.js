const express = require('express');
const router = express.Router();
const db = require('./db');

// =========================
// HELPER: validate number
// =========================
const isValidNumber = (value) => {
  return value !== undefined && !isNaN(value);
};

// =========================
// GET ALL BUDGETS (FILTER)
// =========================
router.get('/budgets', async (req, res) => {
  try {
    const { month, year, categoryId } = req.query;

    let query = 'SELECT * FROM budgets WHERE 1=1';
    let params = [];

    if (month) {
      if (!isValidNumber(month)) {
        return res.status(400).json({ message: 'Invalid month' });
      }
      query += ' AND month = ?';
      params.push(Number(month));
    }

    if (year) {
      if (!isValidNumber(year)) {
        return res.status(400).json({ message: 'Invalid year' });
      }
      query += ' AND year = ?';
      params.push(Number(year));
    }

    if (categoryId) {
      if (!isValidNumber(categoryId)) {
        return res.status(400).json({ message: 'Invalid categoryId' });
      }
      query += ' AND category_id = ?';
      params.push(Number(categoryId));
    }

    const [rows] = await db.query(query, params);
    res.json(rows);

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});
router.get('/budgets/summary', async (req, res) => {
  try {
    const { month, year } = req.query;

    let query = `
      SELECT
        b.id AS budgetId,
        b.amount AS budgetAmount,
        b.month,
        b.year,

        c.name AS categoryName,
        c.icon AS categoryIcon,

        COALESCE(SUM(t.amount), 0) AS spentAmount,
        (b.amount - COALESCE(SUM(t.amount), 0)) AS remaining

      FROM budgets b
      LEFT JOIN categories c ON b.category_id = c.id
      LEFT JOIN transactions t
        ON t.category_id = b.category_id
        AND t.type = 'expense'
        AND MONTH(t.date) = b.month
        AND YEAR(t.date) = b.year
    `;

    let params = [];

    query += ` WHERE 1=1 `;

    if (month) {
      query += ` AND b.month = ?`;
      params.push(month);
    }

    if (year) {
      query += ` AND b.year = ?`;
      params.push(year);
    }

    query += `
      GROUP BY b.id, c.name, c.icon
    `;

    const [rows] = await db.query(query, params);

    res.json(rows);

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

// =========================
// GET BY ID
// =========================
router.get('/budgets/:id', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM budgets WHERE id = ?',
      [req.params.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: 'Budget not found' });
    }

    res.json(rows[0]);

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

// =========================
// CREATE BUDGET
// =========================
router.post('/budgets', async (req, res) => {
  try {
    const { category_id, amount, month, year } = req.body;

    // Validate
    if (!category_id || !amount || !month || !year) {
      return res.status(400).json({ message: 'Missing fields' });
    }

    // Check duplicate
    const [existing] = await db.query(
      'SELECT id FROM budgets WHERE category_id=? AND month=? AND year=?',
      [category_id, month, year]
    );

    if (existing.length > 0) {
      return res.status(400).json({ message: 'Budget already exists' });
    }

    const [result] = await db.query(
      'INSERT INTO budgets (category_id, amount, month, year) VALUES (?, ?, ?, ?)',
      [category_id, amount, month, year]
    );

    res.status(201).json({
      message: 'Budget added',
      id: result.insertId
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

// =========================
// UPDATE BUDGET
// =========================
router.put('/budgets/:id', async (req, res) => {
  try {
    const { category_id, amount, month, year } = req.body;

    const [result] = await db.query(
      'UPDATE budgets SET category_id=?, amount=?, month=?, year=? WHERE id=?',
      [category_id, amount, month, year, req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Budget not found' });
    }

    res.json({ message: 'Budget updated' });

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

// =========================
// DELETE BUDGET
// =========================
router.delete('/budgets/:id', async (req, res) => {
  try {
    const [result] = await db.query(
      'DELETE FROM budgets WHERE id=?',
      [req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Budget not found' });
    }

    res.json({ message: 'Budget deleted' });

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

// =========================
// SUMMARY (OPTIMIZED)
// =========================


// =========================
// EXPORT
// =========================
module.exports = router;