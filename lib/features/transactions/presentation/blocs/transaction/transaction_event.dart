import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_state.dart';

abstract class TransactionEvent {}

// =====================
// CRUD
// =====================
class LoadTransactions extends TransactionEvent {
  final int? categoryId;
  final int? day;
  final int? month;
  final int? year;

  LoadTransactions({this.day,this.categoryId,this.month, this.year});
}

class AddTransaction extends TransactionEvent {
  final TransactionModel transaction;
  AddTransaction(this.transaction);
}

class LoadDayTransactions extends TransactionEvent {
  final int day;
  final int month;
  final int year;

  LoadDayTransactions({
    required this.day,
    required this.month,
    required this.year,
  });
}

class UpdateTransaction extends TransactionEvent {
  final TransactionModel transaction;
  UpdateTransaction(this.transaction);
}

class DeleteTransaction extends TransactionEvent {
  final String id;
  DeleteTransaction(this.id);
}

// =====================
// FILTER
// =====================
class ChangeFilterTypeTransaction extends TransactionEvent {
  final FilterType filterType;
  final DateTime? fromDate;
  final DateTime? toDate;

  ChangeFilterTypeTransaction(this.filterType, {this.fromDate, this.toDate});
}


class SetSelectedDate extends TransactionEvent {
  final DateTime date;
  SetSelectedDate(this.date);
}

class NextDate extends TransactionEvent {}

class PreviousDate extends TransactionEvent {}

class ResetFilter extends TransactionEvent {}

class LoadTransactionBalance extends TransactionEvent{
  final int? day;
  final int? month;
  final int? year;


  LoadTransactionBalance(this.day,this.month, this.year);
}

class LoadBudgetTransactions extends TransactionEvent {
  final int? categoryId;
  final int? month;
  final int? year;

  LoadBudgetTransactions({
    this.categoryId,
    this.month,
    this.year,
  });
}