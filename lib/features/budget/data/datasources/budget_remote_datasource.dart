import 'package:dio/dio.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_summary_model.dart';

import '../models/budget_model.dart';

class BudgetRemoteDatasource {
  Dio dio;

  BudgetRemoteDatasource(this.dio);

  Future<List<BudgetModel>> getBudgetAll(
    int? month,
    int? year,
    int? categoryId,
  ) async {
    final res = await dio.get(
      '/budgets',
      queryParameters: {
        if (month != null) 'month': month,
        if (year != null) 'year': year,
        if (categoryId != null) 'categoryId': categoryId,
      },
    );

    return (res.data as List).map((e) => BudgetModel.fromJson(e)).toList();
  }

  // Future<List<BudgetModel>> getBudgetById(int id) async {
  //   final res = await dio.get('budget/:$id');
  //
  //   return (res.data as List).map((e) => BudgetModel.fromJson(e)).toList();
  // }

  Future<void> createBudget(BudgetModel budget) async {
    await dio.post('/budget', data: budget.toJson());
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await dio.put('/budget/${budget.id}', data: budget.toJson());
  }

  Future<void> deleteBudget(String id) async {
    await dio.delete('/budget/$id');
  }

  Future<List<BudgetSummaryModel>> getBudgetSummary(
    int? month,
    int? year,
  ) async {
    final res = await dio.get(
      '/budgets/summary',
      queryParameters: {'month': month, 'year': year},
    );
    return (res.data as List)
        .map((e) => BudgetSummaryModel.fromJson(e))
        .toList();
  }

  Future<void> deleteAllBudgets() async {
    await dio.delete('/budgets');
  }
}
