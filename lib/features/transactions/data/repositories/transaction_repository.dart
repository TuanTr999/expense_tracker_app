import 'package:expense_tracker_app/features/transactions/data/models/transaction_balance_model.dart';

import '../../data/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionModel transaction);

  Future<List<TransactionModel>> getTransactions({int? categoryId,int? day, int? month, int? year});

  Future<void> updateTransaction(TransactionModel transaction);

  Future<void> deleteTransaction(String id);

  Future<BalanceModel> getTransactionsBalance({int? day,int? month, int? year});
}