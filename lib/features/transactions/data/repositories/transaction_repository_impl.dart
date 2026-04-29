import 'package:expense_tracker_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:expense_tracker_app/features/transactions/data/repositories/transaction_repository.dart';

import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remote;

  TransactionRepositoryImpl(this.remote);

  @override
  Future<List<TransactionModel>> getTransactions() {
    return remote.getTransactions();
  }

  @override
  Future<void> addTransaction(TransactionModel t) {
    return remote.addTransaction(t);
  }

  @override
  Future<void> updateTransaction(TransactionModel t) {
    return remote.updateTransaction(t);
  }

  @override
  Future<void> deleteTransaction(String id) {
    return remote.deleteTransaction(id);
  }
}