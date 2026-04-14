import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/transaction_model.dart';

class TransactionLocalDataSource {
  static Database? _database;

  // 🔹 mở database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'transactions.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id TEXT PRIMARY KEY,
            title TEXT,
            image TEXT,
            amount REAL,
            date TEXT,
            type TEXT
          )
        ''');
      },
    );
  }

  // ==============================
  // 🔥 CRUD
  // ==============================

  // ➕ ADD
  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await database;

    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 📥 GET ALL
  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;

    final maps = await db.query('transactions', orderBy: 'date DESC');

    return maps.map((e) => TransactionModel.fromMap(e)).toList();
  }

  // ✏️ UPDATE
  Future<void> updateTransaction(TransactionModel transaction) async {
    final db = await database;

    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // ❌ DELETE
  Future<void> deleteTransaction(String id) async {
    final db = await database;

    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
