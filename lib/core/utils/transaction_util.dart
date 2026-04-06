import '../../models/transaction_model.dart';

double calculateTotalExpense(List<TransactionModel> transactions) {
  double total = 0;
  for (var t in transactions) {
    if (t.type == TransactionType.expense && t.amount > 0) {
      total += t.amount;
    }
  }
  return total;
}

double calculateTotalIncome(List<TransactionModel> transactions) {
  double total = 0;
  for (var t in transactions) {
    if (t.type == TransactionType.income && t.amount > 0) {
      total += t.amount;
    }
  }
  return total;
}
