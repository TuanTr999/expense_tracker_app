import '../../models/transaction_model.dart';

List<TransactionModel> filteredTransactions(
  int selected,
  List<TransactionModel> transactions,
) {
  final now = DateTime.now();

  switch (selected) {
    case 0: // Today
      return transactions.where((t) {
        return t.date.year == now.year &&
            t.date.month == now.month &&
            t.date.day == now.day;
      }).toList();

    case 1: // Month
      return transactions.where((t) {
        return t.date.year == now.year && t.date.month == now.month;
      }).toList();

    case 2: // Year
      return transactions.where((t) {
        return t.date.year == now.year;
      }).toList();

    case 3: // All
      return transactions;

    default:
      return transactions;
  }
}

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
