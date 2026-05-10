import 'package:dio/dio.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_summary_model.dart';

import '../models/budget_model.dart';

class BudgetRemoteDatasource {
  final Dio dio;

  BudgetRemoteDatasource(this.dio);

  // =========================
  // GET ALL BUDGETS
  // =========================
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

    return (res.data as List)
        .map((e) => BudgetModel.fromJson(e))
        .toList();
  }

  // =========================
  // CREATE
  // =========================
  Future<void> createBudget(BudgetModel budget) async {
    await dio.post(
      '/budgets',
      data: budget.toJson(),
    );
  }

  // =========================
  // UPDATE
  // =========================
  Future<void> updateBudget(BudgetModel budget) async {
    await dio.put(
      '/budgets/${budget.id}',
      data: budget.toJson(),
    );
  }

  // =========================
  // DELETE
  // =========================
  Future<void> deleteBudget(String id) async {
    await dio.delete('/budgets/$id');
  }

  // =========================
  // SUMMARY
  // =========================
  Future<List<BudgetSummaryModel>> getBudgetSummary(
      int? month,
      int? year,
      ) async {
    final res = await dio.get(
      '/budgets/summary',
      queryParameters: {
        if (month != null) 'month': month,
        if (year != null) 'year': year,
      },
    );

    return (res.data as List)
        .map((e) => BudgetSummaryModel.fromJson(e))
        .toList();
  }

  // =========================
  // DELETE ALL
  // =========================
  Future<void> deleteAllBudgets() async {
    await dio.delete('/budgets');
  }
}