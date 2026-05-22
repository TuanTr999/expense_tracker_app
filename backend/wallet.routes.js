const express = require('express');
const router = express.Router();
const db = require('./db');
const verifyFirebaseToken = require('./middleware/auth.middleware');

// Lấy toàn bộ ví / thẻ
router.get('/wallets', verifyFirebaseToken, async (req, res) => {
  const userId = req.user.uid;

  try {
    const [rows] = await db.query(
      `
      SELECT *
      FROM wallets
      WHERE user_id = ?
      ORDER BY
        FIELD(type, 'cash', 'bank', 'ewallet'),
        id DESC
      `,
      [userId]
    );

    res.json(rows);
  } catch (error) {
    res.status(500).json({
      message: 'Lỗi lấy danh sách ví',
      error: error.message,
    });
  }
});

// Thêm ví / thẻ
router.post('/wallets', verifyFirebaseToken, async (req, res) => {
  const userId = req.user.uid;
  const { name, type, icon, balance } = req.body;

  if (!name || !type) {
    return res.status(400).json({
      message: 'name and type are required',
    });
  }

  try {
    const [result] = await db.query(
      `
      INSERT INTO wallets
      (user_id, name, type, icon, balance)
      VALUES (?, ?, ?, ?, ?)
      `,
      [
        userId,
        name,
        type,
        icon || null,
        balance || 0,
      ]
    );

    res.json({
      id: result.insertId,
      user_id: userId,
      name,
      type,
      icon,
      balance: balance || 0,
    });
  } catch (error) {
    res.status(500).json({
      message: 'Lỗi thêm ví',
      error: error.message,
    });
  }
});

// Xóa ví / thẻ
router.delete('/wallets/:id', verifyFirebaseToken, async (req, res) => {
  const userId = req.user.uid;
  const { id } = req.params;

  try {
    await db.query(
      `
      DELETE FROM wallets
      WHERE id = ? AND user_id = ?
      `,
      [id, userId]
    );

    res.json({
      message: 'Xóa ví thành công',
    });
  } catch (error) {
    res.status(500).json({
      message: 'Lỗi xóa ví',
      error: error.message,
    });
  }
});

router.put('/wallets/:id/balance', verifyFirebaseToken, async (req, res) => {
  const userId = req.user.uid;
  const { id } = req.params;
  const { balance } = req.body;

  if (balance == null || isNaN(Number(balance))) {
    return res.status(400).json({
      message: 'balance is required and must be number',
    });
  }

  try {
    await db.query(
      `
      UPDATE wallets
      SET balance = ?
      WHERE id = ? AND user_id = ?
      `,
      [Number(balance), id, userId]
    );

    res.json({
      message: 'Cập nhật số dư thành công',
    });
  } catch (error) {
    res.status(500).json({
      message: 'Lỗi cập nhật số dư',
      error: error.message,
    });
  }
});

module.exports = router;