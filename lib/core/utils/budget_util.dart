import 'package:expense_tracker_app/features/budget/data/models/budget_model.dart';

double calculateTotalBudget (List<BudgetModel> budgets){
  double total = 0;
  for (var b in budgets){
    total += b.amount;
  }
  return total;
}