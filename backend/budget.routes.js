const express = require('express');
const router = express.Router();
const db = require('./db');

// =========================
// HELPER
// =========================
const isValidNumber = (value) => {
  return value !== undefined && !isNaN(value);
};

// =========================
// GET ALL BUDGETS
// =========================
router.get('/budgets', async (req, res) => {
  try {
    const { month, year, categoryId } = req.query;

    let query = `
      SELECT
        b.*,
        c.name AS categoryName,
        c.icon AS categoryIcon
      FROM budgets b
      LEFT JOIN categories c
        ON c.id = b.category_id
      WHERE 1=1
    `;

    let params = [];

    if (month) {
      if (!isValidNumber(month)) {
        return res.status(400).json({
          message: 'Invalid month',
        });
      }

      query += ' AND b.month = ?';
      params.push(Number(month));
    }

    if (year) {
      if (!isValidNumber(year)) {
        return res.status(400).json({
          message: 'Invalid year',
        });
      }

      query += ' AND b.year = ?';
      params.push(Number(year));
    }

    if (categoryId) {
      if (!isValidNumber(categoryId)) {
        return res.status(400).json({
          message: 'Invalid categoryId',
        });
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
// =========================
// GET SUMMARY
// =========================
router.get('/budgets/summary', async (req, res) => {
  try {
    const { month, year } = req.query;

    const hasMonth = month !== undefined && month !== null && month !== '';
    const hasYear  = year  !== undefined && year  !== null && year  !== '';

    // Build điều kiện ON cho budgets
    let budgetOnClause  = 'ON b.category_id = c.id';
    let txnWhereClause  = "AND t.type = 'expense'";

    let params = [];

    if (hasMonth && hasYear) {
      budgetOnClause += ' AND b.month = ? AND b.year = ?';
      txnWhereClause += ' AND MONTH(t.date) = ? AND YEAR(t.date) = ?';
      params = [month, year, month, year];
    } else if (!hasMonth && hasYear) {
      budgetOnClause += ' AND b.year = ?';
      txnWhereClause += ' AND YEAR(t.date) = ?';
      params = [year, year];
    }

    const query = `
      SELECT
        c.id   AS categoryId,
        c.name AS categoryName,
        c.icon AS categoryIcon,

        COALESCE(b.id,     0) AS budgetId,
        COALESCE(b.amount, 0) AS budgetAmount,

        COALESCE(SUM(t.amount), 0) AS spentAmount,

        (
          COALESCE(b.amount, 0)
          - COALESCE(SUM(t.amount), 0)
        ) AS remaining

      FROM categories c

      LEFT JOIN budgets b
        ${budgetOnClause}

      LEFT JOIN transactions t
        ON t.category_id = c.id
        ${txnWhereClause}

      WHERE c.type = 'expense'

      GROUP BY
        c.id,
        c.name,
        c.icon,
        b.id,
        b.amount
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
      `
      SELECT
        b.*,
        c.name AS categoryName,
        c.icon AS categoryIcon
      FROM budgets b
      LEFT JOIN categories c
        ON c.id = b.category_id
      WHERE b.id = ?
      `,
      [req.params.id]
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
router.post('/budgets', async (req, res) => {
  try {
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

    // check duplicate
    const [existing] = await db.query(
      `
      SELECT id
      FROM budgets
      WHERE category_id = ?
      AND month = ?
      AND year = ?
      `,
      [category_id, month, year]
    );

    if (existing.length > 0) {
      // update luôn thay vì báo lỗi
      await db.query(
        `
        UPDATE budgets
        SET amount = ?
        WHERE category_id = ?
        AND month = ?
        AND year = ?
        `,
        [
          amount,
          category_id,
          month,
          year,
        ]
      );

      return res.json({
        message: 'Budget updated',
      });
    }

    // create new
    const [result] = await db.query(
      `
      INSERT INTO budgets (
        category_id,
        amount,
        month,
        year
      )
      VALUES (?, ?, ?, ?)
      `,
      [
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
router.put('/budgets/:id', async (req, res) => {
  try {
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
      `,
      [
        category_id,
        amount,
        month,
        year,
        req.params.id,
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
router.delete('/budgets', async (req, res) => {
  try {
    const [result] = await db.query(
      'DELETE FROM budgets'
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
router.delete('/budgets/:id', async (req, res) => {
  try {
    const [result] = await db.query(
      'DELETE FROM budgets WHERE id = ?',
      [req.params.id]
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