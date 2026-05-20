import 'package:dio/dio.dart';
import 'package:expense_tracker_app/features/transactions/data/models/transaction_balance_model.dart';
import '../models/transaction_model.dart';

class TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSource(this.dio);

  Future<List<TransactionModel>> getTransactions({
    int? categoryId,
    int? day,
    int? month,
    int? year,
  }) async {
    final query = {
      if (categoryId != null) 'categoryId': categoryId,
      if (day != null) 'day': day,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
    };

    final res = await dio.get(
      '/transactions',
      queryParameters: query,
    );

    return (res.data as List)
        .map((e) => TransactionModel.fromMap(e))
        .toList();
  }

  Future<BalanceModel> getTransactionsBalance({
    int? day,
    int? month,
    int? year,
  }) async {
    final query = {
      if (day != null) 'day': day,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
    };

    final res = await dio.get(
      '/transactions/balance',
      queryParameters: query,
    );

    return  BalanceModel.fromJson(res.data);
  }

  Future<void> addTransaction(TransactionModel t) async {
    await dio.post('/transactions', data: t.toMap());
  }

  Future<void> updateTransaction(TransactionModel t) async {
    await dio.put('/transactions/${t.id}', data: t.toMap());
  }

  Future<void> deleteTransaction(String id) async {
    await dio.delete('/transactions/$id');
  }
}
