import 'package:dio/dio.dart';
import '../models/transaction_model.dart';

class TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSource(this.dio);

  Future<List<TransactionModel>> getTransactions() async {
    final res = await dio.get('/transactions');

    print('=== DEBUG ===');
    print('Status: ${res.statusCode}');
    print('Data type: ${res.data.runtimeType}');
    print('Data: ${res.data}');

    final data = res.data as List;
    print('List length: ${data.length}');

    final result = data.map((e) {
      print('Parsing: $e');
      return TransactionModel.fromMap(e);
    }).toList();

    print('Parsed ${result.length} transactions');
    print('=============');

    return result;
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
