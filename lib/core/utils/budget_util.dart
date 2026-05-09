import 'package:expense_tracker_app/features/budget/data/models/budget_summary_model.dart';

double calculateTotalBudget (List<BudgetSummaryModel> budgets){
  double total = 0;
  for (var b in budgets){
    total += b.budgetAmount;
  }
  return total;
}

double calculateTotalSpentAmountBudget (List<BudgetSummaryModel> budgets){
  double total = 0;
  for (var b in budgets){
    total += b.spentAmount;
  }
  return total;
}

double calculateTotalRemainingBudget (List<BudgetSummaryModel> budgets){
  double total = 0;
  for (var b in budgets){
    total += b.remaining;
  }
  return total;
}