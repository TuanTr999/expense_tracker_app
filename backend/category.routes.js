const express = require('express');
const router = express.Router();
const db = require('./db');
const verifyFirebaseToken = require('./middleware/auth.middleware');

// GET ALL
router.get('/categories', verifyFirebaseToken, async (req, res) => {
  const { type } = req.query;
  const userId = req.user.uid;

  let query = 'SELECT * FROM categories WHERE user_id = ?';
  let params = [userId];

  if (type) {
    query += ' AND type = ?';
    params.push(type);
  }

  const [rows] = await db.query(query, params);
  res.json(rows);
});

// INSERT
router.post('/categories', verifyFirebaseToken, async (req, res) => {
  const { name, icon, type } = req.body;
  const userId = req.user.uid;

  await db.query(
    'INSERT INTO categories (user_id, name, icon, type) VALUES (?, ?, ?, ?)',
    [userId, name, icon, type]
  );

  res.json({ message: 'Category added' });
});

// UPDATE
router.put('/categories/:id', verifyFirebaseToken, async (req, res) => {
  const { name, icon, type } = req.body;
  const userId = req.user.uid;

  await db.query(
    'UPDATE categories SET name=?, icon=?, type=? WHERE id=? AND user_id=?',
    [name, icon, type, req.params.id, userId]
  );

  res.json({ message: 'Category updated' });
});

// DELETE
router.delete('/categories/:id', verifyFirebaseToken, async (req, res) => {
  const id = req.params.id;
  const userId = req.user.uid;

  try {
    await db.query(
      'DELETE FROM transactions WHERE category_id = ? AND user_id = ?',
      [id, userId]
    );

    await db.query(
      'DELETE FROM categories WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    res.json({
      message: 'Đã xóa category và toàn bộ transaction liên quan'
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Delete failed' });
  }
});

// RESET DEFAULT
router.post('/categories/reset', verifyFirebaseToken, async (req, res) => {
  try {
    const userId = req.user.uid;

    await db.query(
      `
      DELETE FROM transactions
      WHERE user_id = ?
        AND category_id IN (
          SELECT id FROM categories WHERE user_id = ?
        )
      `,
      [userId, userId]
    );

    await db.query(
      'DELETE FROM categories WHERE user_id = ?',
      [userId]
    );

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

    for (let item of defaults) {
      await db.query(
        'INSERT INTO categories (user_id, name, icon, type) VALUES (?, ?, ?, ?)',
        [userId, ...item]
      );
    }

    res.json({
      message: 'Reset categories thành công'
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: 'Reset failed'
    });
  }
});

module.exports = router;