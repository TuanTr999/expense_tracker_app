const express = require('express');
const router = express.Router();
const db = require('./db');
const verifyFirebaseToken = require('./middleware/auth.middleware');

const createDefaultCategories = async (userId) => {
  const defaults = [
    ['Ăn uống', 'food.png', 'expense'],
    ['Giải trí', 'entertainment.png', 'expense'],
    ['Sức khỏe', 'healthcare.png', 'expense'],
    ['Nhà ở', 'house.png', 'expense'],
    ['Mua sắm', 'shopping-cart.png', 'expense'],
    ['Di chuyển', 'transportation.png', 'expense'],
    ['Giáo dục', 'education.png', 'expense'],
    ['Lương', 'salary.png', 'income'],
    ['Thưởng', 'bonus.png', 'income'],
    ['Đầu tư', 'investment.png', 'income'],
    ['Quà tặng', 'giftbox.png', 'income'],
  ];

  for (const item of defaults) {
    await db.query(
      'INSERT INTO categories (user_id, name, icon, type) VALUES (?, ?, ?, ?)',
      [userId, ...item]
    );
  }
};

const createDefaultWallets = async (userId) => {
  const defaults = [
    ['Tiền mặt', 'cash', 'cash.png', 0],
    ['Momo', 'ewallet', 'momo.png', 0],
    ['ZaloPay', 'ewallet', 'zalopay.png', 0],
    ['VNPay', 'ewallet', 'vnpay.png', 0],
    ['MB Bank', 'bank', 'mb.png', 0],
    ['BIDV', 'bank', 'bidv.png', 0],
    ['Techcombank', 'bank', 'techcombank.png', 0],
    ['Vietcombank', 'bank', 'vietcombank.png', 0],
    ['VietinBank', 'bank', 'vietinbank.png', 0],
  ];

  for (const item of defaults) {
    await db.query(
      'INSERT INTO wallets (user_id, name, type, icon, balance) VALUES (?, ?, ?, ?, ?)',
      [userId, ...item]
    );
  }
};

router.post('/users/sync', verifyFirebaseToken, async (req, res) => {
  try {
    const userId = req.user.uid;
    const email = req.user.email;
    const name = req.user.name;
    const picture = req.user.picture;

    const [users] = await db.query(
      'SELECT uid FROM users WHERE uid = ?',
      [userId]
    );

    if (users.length === 0) {
      await db.query(
        `
        INSERT INTO users (uid, email, display_name, photo_url)
        VALUES (?, ?, ?, ?)
        `,
        [userId, email, name, picture]
      );

      await createDefaultCategories(userId);
      await createDefaultWallets(userId);

      return res.status(201).json({
        message: 'User created and default data initialized',
      });
    }

    res.json({
      message: 'User already exists',
    });

  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: 'Sync user failed',
    });
  }
});

module.exports = router;