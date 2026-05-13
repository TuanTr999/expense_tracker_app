const express = require('express');
const router = express.Router();
const db = require('./db');

// GET ALL
router.get('/categories', async (req, res) => {
  const { type } = req.query;

  let query = 'SELECT * FROM categories';
  let params = [];

  if (type) {
    query += ' WHERE type = ?';
    params.push(type);
  }

  const [rows] = await db.query(query, params);
  res.json(rows);
});


// INSERT
router.post('/categories', async (req, res) => {
  const { name, icon, type } = req.body;

  await db.query(
    'INSERT INTO categories (name, icon, type) VALUES (?, ?, ?)',
    [name, icon, type]
  );

  res.json({ message: 'Category added' });
});


// UPDATE
router.put('/categories/:id', async (req, res) => {
  const { name, icon, type } = req.body;

  await db.query(
    'UPDATE categories SET name=?, icon=?, type=? WHERE id=?',
    [name, icon, type, req.params.id]
  );

  res.json({ message: 'Category updated' });
});

// DELETE
router.delete('/categories/:id', async (req, res) => {
  const id = req.params.id;

  try {
    // 1. Xóa transaction trước
    await db.query(
      'DELETE FROM transactions WHERE category_id = ?',
      [id]
    );

    // 2. Xóa category
    await db.query(
      'DELETE FROM categories WHERE id = ?',
      [id]
    );

    res.json({
      message: 'Đã xóa category và toàn bộ transaction liên quan'
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Delete failed' });
  }
});

// HAS TRANSACTION
//router.get('/categories/:id/has-transaction', async (req, res) => {
//  const [rows] = await db.query(
//    'SELECT id FROM transactions WHERE category_id=? LIMIT 1',
//    [req.params.id]
//  );
//
//  res.json({ hasTransaction: rows.length > 0 });
//});


// RESET DEFAULT
// RESET DEFAULT
router.post('/categories/reset', async (req, res) => {
  try {

   // 1. Xóa transaction có category
       await db.query(`
         DELETE FROM transactions
         WHERE category_id IN (
           SELECT id FROM categories
         )
       `);

       // 2. Xóa categories
       await db.query('DELETE FROM categories');

       res.json({
         message: 'All categories deleted'
       });

     } catch (error) {
       console.error(error);

       res.status(500).json({
         message: 'Reset failed'
       });

    // 3. Xóa category
    await db.query('DELETE FROM categories');

    // 4. Insert default categories
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
        'INSERT INTO categories (name, icon, type) VALUES (?, ?, ?)',
        item
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