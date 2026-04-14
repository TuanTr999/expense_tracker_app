import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';

import '../enums/app_type.dart';

double calculateTotalExpense(List<TransactionModel> transactions) {
  double total = 0;
  for (var t in transactions) {
    if (t.type == AppType.expense && t.amount > 0) {
      total += t.amount;
    }
  }
  return total;
}

double calculateTotalIncome(List<TransactionModel> transactions) {
  double total = 0;
  for (var t in transactions) {
    if (t.type == AppType.income && t.amount > 0) {
      total += t.amount;
    }
  }
  return total;
}
