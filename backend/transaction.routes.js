const express = require('express');
const router = express.Router();
const db = require('./db');
const verifyFirebaseToken = require('./middleware/auth.middleware');

function getWalletChange(type, amount) {
  const value = Number(amount);

  if (type === 'income') return value;
  if (type === 'expense') return -value;

  return 0;
}

// GET BALANCE
router.get(
  '/transactions/balance',
  verifyFirebaseToken,
  async (req, res) => {

    const userId = req.user.uid;

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

      // DAY
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
            AND DATE(date) < ?
          `,
          [
            userId,
            `${currentYear}-${String(currentMonth).padStart(2, '0')}-${String(currentDay).padStart(2, '0')}`,
          ]
        );

        const currentBalance = Number(currentRows[0].balance);
        const previousBalance = Number(previousRows[0].balance);

        return res.json({
          type: 'daily',
          day: currentDay,
          month: currentMonth,
          year: currentYear,
          currentBalance,
          previousBalance,
          totalBalance: previousBalance + currentBalance,
        });
      }

      // MONTH
      if (currentMonth) {

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
            AND (
              YEAR(date) < ?
              OR (YEAR(date) = ? AND MONTH(date) < ?)
            )
          `,
          [userId, currentYear, currentYear, currentMonth]
        );

        const currentBalance = Number(currentRows[0].balance);
        const previousBalance = Number(previousRows[0].balance);

        return res.json({
          type: 'monthly',
          month: currentMonth,
          year: currentYear,
          currentBalance,
          previousBalance,
          totalBalance: previousBalance + currentBalance,
        });
      }

      // YEAR
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
          AND YEAR(date) < ?
        `,
        [userId, currentYear]
      );

      const currentBalance = Number(currentRows[0].balance);
      const previousBalance = Number(previousRows[0].balance);

      return res.json({
        type: 'yearly',
        year: currentYear,
        currentBalance,
        previousBalance,
        totalBalance: previousBalance + currentBalance,
      });

    } catch (error) {
      console.error(error);

      res.status(500).json({
        message: 'Failed to calculate balance',
      });
    }
  }
);

// GET
router.get('/transactions', verifyFirebaseToken, async (req, res) => {

  const userId = req.user.uid;

  const { categoryId, day, month, year } = req.query;

  try {

    let query = `
      SELECT
        t.*,
        c.icon AS category_icon,
        c.name AS category_name,
        w.name AS wallet_name,
        w.icon AS wallet_icon,
        w.type AS wallet_type
      FROM transactions t
      LEFT JOIN categories c ON t.category_id = c.id
      LEFT JOIN wallets w ON t.wallet_id = w.id
      WHERE t.user_id = ?
    `;

    const params = [userId];

    if (categoryId) {
      query += ' AND t.category_id = ?';
      params.push(categoryId);
    }

    if (day && month && year) {
      query += ' AND DAY(t.date) = ? AND MONTH(t.date) = ? AND YEAR(t.date) = ?';
      params.push(day, month, year);
    }

    else if (month && year) {
      query += ' AND MONTH(t.date) = ? AND YEAR(t.date) = ?';
      params.push(month, year);
    }

    else if (year) {
      query += ' AND YEAR(t.date) = ?';
      params.push(year);
    }

    query += ' ORDER BY t.date DESC';

    const [rows] = await db.query(query, params);

    res.json(rows);

  } catch (error) {

    console.error(error);

    res.status(500).json({
      message: 'Failed to get transactions',
    });
  }
});

// POST
router.post('/transactions', verifyFirebaseToken, async (req, res) => {

  const userId = req.user.uid;

  const {
    id,
    title,
    amount,
    date,
    type,
    category_id,
    wallet_id
  } = req.body;

  if (!wallet_id) {
    return res.status(400).json({
      message: 'wallet_id is required',
    });
  }

  const value = Number(amount);
  const walletChange = getWalletChange(type, value);

  try {

    await db.query('START TRANSACTION');

    await db.query(
      `
      INSERT INTO transactions
      (id, title, amount, date, type, category_id, wallet_id, user_id)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        id,
        title,
        value,
        date,
        type,
        category_id,
        wallet_id,
        userId
      ]
    );

    await db.query(
      `
      UPDATE wallets
      SET balance = balance + ?
      WHERE id = ? AND user_id = ?
      `,
      [walletChange, wallet_id, userId]
    );

    await db.query('COMMIT');

    res.json({
      message: 'Added'
    });

  } catch (error) {

    await db.query('ROLLBACK');

    console.error(error);

    res.status(500).json({
      message: 'Failed to add transaction',
    });
  }
});

// PUT
router.put('/transactions/:id', verifyFirebaseToken, async (req, res) => {

  const userId = req.user.uid;

  const {
    title,
    amount,
    date,
    type,
    category_id,
    wallet_id
  } = req.body;

  if (!wallet_id) {
    return res.status(400).json({
      message: 'wallet_id is required',
    });
  }

  try {

    await db.query('START TRANSACTION');

    const [oldRows] = await db.query(
      `
      SELECT amount, type, wallet_id
      FROM transactions
      WHERE id = ? AND user_id = ?
      `,
      [req.params.id, userId]
    );

    if (oldRows.length === 0) {

      await db.query('ROLLBACK');

      return res.status(404).json({
        message: 'Transaction not found',
      });
    }

    const oldTransaction = oldRows[0];

    const oldChange = getWalletChange(
      oldTransaction.type,
      oldTransaction.amount
    );

    await db.query(
      `
      UPDATE wallets
      SET balance = balance - ?
      WHERE id = ? AND user_id = ?
      `,
      [oldChange, oldTransaction.wallet_id, userId]
    );

    const newAmount = Number(amount);
    const newChange = getWalletChange(type, newAmount);

    await db.query(
      `
      UPDATE transactions
      SET title = ?, amount = ?, date = ?, type = ?, category_id = ?, wallet_id = ?
      WHERE id = ? AND user_id = ?
      `,
      [
        title,
        newAmount,
        date,
        type,
        category_id,
        wallet_id,
        req.params.id,
        userId,
      ]
    );

    await db.query(
      `
      UPDATE wallets
      SET balance = balance + ?
      WHERE id = ? AND user_id = ?
      `,
      [newChange, wallet_id, userId]
    );

    await db.query('COMMIT');

    res.json({
      message: 'Updated'
    });

  } catch (error) {

    await db.query('ROLLBACK');

    console.error(error);

    res.status(500).json({
      message: 'Failed to update transaction',
    });
  }
});

// DELETE
router.delete('/transactions/:id', verifyFirebaseToken, async (req, res) => {

  const userId = req.user.uid;

  try {

    await db.query('START TRANSACTION');

    const [oldRows] = await db.query(
      `
      SELECT amount, type, wallet_id
      FROM transactions
      WHERE id = ? AND user_id = ?
      `,
      [req.params.id, userId]
    );

    if (oldRows.length === 0) {

      await db.query('ROLLBACK');

      return res.status(404).json({
        message: 'Transaction not found',
      });
    }

    const oldTransaction = oldRows[0];

    const oldChange = getWalletChange(
      oldTransaction.type,
      oldTransaction.amount
    );

    await db.query(
      `
      UPDATE wallets
      SET balance = balance - ?
      WHERE id = ? AND user_id = ?
      `,
      [oldChange, oldTransaction.wallet_id, userId]
    );

    await db.query(
      `
      DELETE FROM transactions
      WHERE id = ? AND user_id = ?
      `,
      [req.params.id, userId]
    );

    await db.query('COMMIT');

    res.json({
      message: 'Deleted'
    });

  } catch (error) {

    await db.query('ROLLBACK');

    console.error(error);

    res.status(500).json({
      message: 'Failed to delete transaction',
    });
  }
});

module.exports = router;