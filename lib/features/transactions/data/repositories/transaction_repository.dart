import '../../data/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionModel transaction);

  Future<List<TransactionModel>> getTransactions({int? categoryId, int? month, int? year});

  Future<void> updateTransaction(TransactionModel transaction);

  Future<void> deleteTransaction(String id);
}