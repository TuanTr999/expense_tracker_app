import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../models/transaction_model.dart';

class TransactionLocalDataSource {
  Future<Database> get database async => await AppDatabase.database;


  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await database;

    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT t.*, c.icon as categoryIcon
      FROM transactions t
      LEFT JOIN categories c ON t.categoryId = c.id
      ORDER BY t.date DESC
    ''');

    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }


  Future<void> updateTransaction(TransactionModel transaction) async {
    final db = await database;

    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }


  Future<void> deleteTransaction(String id) async {
    final db = await database;

    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}