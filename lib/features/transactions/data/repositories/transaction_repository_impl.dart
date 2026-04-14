import 'package:expense_tracker_app/features/transactions/data/repositories/transaction_repository.dart';

import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTransaction(TransactionModel transaction) {
    return localDataSource.insertTransaction(transaction);
  }

  @override
  Future<List<TransactionModel>> getTransactions() {
    return localDataSource.getTransactions();
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) {
    return localDataSource.updateTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) {
    return localDataSource.deleteTransaction(id);
  }
}