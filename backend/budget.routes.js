const express = require('express');
const router = express.Router();
const db = require('./db');
const verifyFirebaseToken = require('./middleware/auth.middleware');

// =========================
// HELPER
// =========================
const isValidNumber = (value) => {
  return value !== undefined && !isNaN(value);
};

// =========================
// GET ALL BUDGETS
// =========================
router.get('/budgets', verifyFirebaseToken, async (req, res) => {
  try {
    const { month, year, categoryId } = req.query;
    const userId = req.user.uid;

    let query = `
      SELECT
        b.*,
        c.name AS categoryName,
        c.icon AS categoryIcon
      FROM budgets b
      LEFT JOIN categories c
        ON c.id = b.category_id
      WHERE b.user_id = ?
    `;

    let params = [userId];

    if (month) {
      if (!isValidNumber(month)) {
        return res.status(400).json({ message: 'Invalid month' });
      }

      query += ' AND b.month = ?';
      params.push(Number(month));
    }

    if (year) {
      if (!isValidNumber(year)) {
        return res.status(400).json({ message: 'Invalid year' });
      }

      query += ' AND b.year = ?';
      params.push(Number(year));
    }

    if (categoryId) {
      if (!isValidNumber(categoryId)) {
        return res.status(400).json({ message: 'Invalid categoryId' });
      }

      query += ' AND b.category_id = ?';
      params.push(Number(categoryId));
    }

    const [rows] = await db.query(query, params);

    res.json(rows);
  } catch (err) {
    console.error(err);

    res.status(500).json({
      message: 'Server error',
    });
  }
});

// =========================
// GET SUMMARY
// =========================
router.get('/budgets/summary', verifyFirebaseToken, async (req, res) => {
  try {
    const { month, year } = req.query;
    const userId = req.user.uid;

    const hasMonth = month !== undefined && month !== null && month !== '';
    const hasYear = year !== undefined && year !== null && year !== '';

    if (!hasYear) {
      return res.status(400).json({
        message: 'Year is required',
      });
    }

    let query = '';
    let params = [];

    if (hasMonth) {
      query = `
        SELECT
          c.id AS categoryId,
          c.name AS categoryName,
          c.icon AS categoryIcon,

          COALESCE(b.id, 0) AS budgetId,
          COALESCE(b.amount, 0) AS budgetAmount,
          COALESCE(b.month, ?) AS month,
          COALESCE(b.year, ?) AS year,

          COALESCE(t.spentAmount, 0) AS spentAmount,

          (
            COALESCE(b.amount, 0)
            - COALESCE(t.spentAmount, 0)
          ) AS remaining

        FROM categories c

        LEFT JOIN budgets b
          ON b.category_id = c.id
          AND b.month = ?
          AND b.year = ?
          AND b.user_id = ?

        LEFT JOIN (
          SELECT
            category_id,
            SUM(amount) AS spentAmount
          FROM transactions
          WHERE type = 'expense'
            AND MONTH(date) = ?
            AND YEAR(date) = ?
            AND user_id = ?
          GROUP BY category_id
        ) t
          ON t.category_id = c.id

        WHERE c.type = 'expense'
      `;

      params = [
        Number(month),
        Number(year),
        Number(month),
        Number(year),
        userId,
        Number(month),
        Number(year),
        userId,
      ];
    } else {
      query = `
        SELECT
          c.id AS categoryId,
          c.name AS categoryName,
          c.icon AS categoryIcon,

          0 AS budgetId,
          COALESCE(b.budgetAmount, 0) AS budgetAmount,
          NULL AS month,
          ? AS year,

          COALESCE(t.spentAmount, 0) AS spentAmount,

          (
            COALESCE(b.budgetAmount, 0)
            - COALESCE(t.spentAmount, 0)
          ) AS remaining

        FROM categories c

        LEFT JOIN (
          SELECT
            category_id,
            SUM(amount) AS budgetAmount
          FROM budgets
          WHERE year = ?
            AND user_id = ?
          GROUP BY category_id
        ) b
          ON b.category_id = c.id

        LEFT JOIN (
          SELECT
            category_id,
            SUM(amount) AS spentAmount
          FROM transactions
          WHERE type = 'expense'
            AND YEAR(date) = ?
            AND user_id = ?
          GROUP BY category_id
        ) t
          ON t.category_id = c.id

        WHERE c.type = 'expense'
      `;

      params = [
        Number(year),
        Number(year),
        userId,
        Number(year),
        userId,
      ];
    }

    const [rows] = await db.query(query, params);

    res.json(rows);
  } catch (err) {
    console.error(err);

    res.status(500).json({
      message: 'Server error',
    });
  }
});

// =========================
// GET BY ID
// =========================
router.get('/budgets/:id', verifyFirebaseToken, async (req, res) => {
  try {
    const userId = req.user.uid;

    const [rows] = await db.query(
      `
      SELECT
        b.*,
        c.name AS categoryName,
        c.icon AS categoryIcon
      FROM budgets b
      LEFT JOIN categories c
        ON c.id = b.category_id
      WHERE b.id = ?
        AND b.user_id = ?
      `,
      [req.params.id, userId]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        message: 'Budget not found',
      });
    }

    res.json(rows[0]);
  } catch (err) {
    console.error(err);

    res.status(500).json({
      message: 'Server error',
    });
  }
});

// =========================
// CREATE BUDGET
// =========================
router.post('/budgets', verifyFirebaseToken, async (req, res) => {
  try {
    const userId = req.user.uid;

    const {
      category_id,
      amount,
      month,
      year,
    } = req.body;

    if (
      !category_id ||
      amount === undefined ||
      !month ||
      !year
    ) {
      return res.status(400).json({
        message: 'Missing fields',
      });
    }

    const [existing] = await db.query(
      `
      SELECT id
      FROM budgets
      WHERE user_id = ?
        AND category_id = ?
        AND month = ?
        AND year = ?
      `,
      [userId, category_id, month, year]
    );

    if (existing.length > 0) {
      await db.query(
        `
        UPDATE budgets
        SET amount = ?
        WHERE user_id = ?
          AND category_id = ?
          AND month = ?
          AND year = ?
        `,
        [
          amount,
          userId,
          category_id,
          month,
          year,
        ]
      );

      return res.json({
        message: 'Budget updated',
      });
    }

    const [result] = await db.query(
      `
      INSERT INTO budgets (
        user_id,
        category_id,
        amount,
        month,
        year
      )
      VALUES (?, ?, ?, ?, ?)
      `,
      [
        userId,
        category_id,
        amount,
        month,
        year,
      ]
    );

    res.status(201).json({
      message: 'Budget created',
      id: result.insertId,
    });
  } catch (err) {
    console.error(err);

    res.status(500).json({
      message: 'Server error',
    });
  }
});

// =========================
// UPDATE BUDGET
// =========================
router.put('/budgets/:id', verifyFirebaseToken, async (req, res) => {
  try {
    const userId = req.user.uid;

    const {
      category_id,
      amount,
      month,
      year,
    } = req.body;

    const [result] = await db.query(
      `
      UPDATE budgets
      SET
        category_id = ?,
        amount = ?,
        month = ?,
        year = ?
      WHERE id = ?
        AND user_id = ?
      `,
      [
        category_id,
        amount,
        month,
        year,
        req.params.id,
        userId,
      ]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: 'Budget not found',
      });
    }

    res.json({
      message: 'Budget updated',
    });
  } catch (err) {
    console.error(err);

    res.status(500).json({
      message: 'Server error',
    });
  }
});

// =========================
// DELETE ALL
// =========================
router.delete('/budgets', verifyFirebaseToken, async (req, res) => {
  try {
    const userId = req.user.uid;

    const [result] = await db.query(
      'DELETE FROM budgets WHERE user_id = ?',
      [userId]
    );

    res.json({
      message: 'All budgets deleted',
      affectedRows: result.affectedRows,
    });
  } catch (err) {
    console.error(err);

    res.status(500).json({
      message: 'Server error',
    });
  }
});

// =========================
// DELETE BY ID
// =========================
router.delete('/budgets/:id', verifyFirebaseToken, async (req, res) => {
  try {
    const userId = req.user.uid;

    const [result] = await db.query(
      'DELETE FROM budgets WHERE id = ? AND user_id = ?',
      [req.params.id, userId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: 'Budget not found',
      });
    }

    res.json({
      message: 'Budget deleted',
    });
  } catch (err) {
    console.error(err);

    res.status(500).json({
      message: 'Server error',
    });
  }
});

module.exports = router;