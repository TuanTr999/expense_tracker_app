import 'package:expense_tracker_app/features/budget/data/models/budget_model.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_summary_model.dart';

abstract class BudgetRepository {
  Future<List<BudgetModel>> getBudgetAll(
    int? month,
    int? year,
    int? categoryId,
  );

  // Future<List<BudgetModel>> getBudgetById(int id);

  Future<void> createBudget(BudgetModel budget);

  Future<void> updateBudget(BudgetModel budget);

  Future<void> deleteBudget(String id);

  Future<List<BudgetSummaryModel>> getBudgetSummary(
    int? month,
    int? year,
  );
}
