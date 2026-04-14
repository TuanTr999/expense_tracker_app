import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';

abstract class TransactionEvent {}

class LoadTransactionEvent extends TransactionEvent {}

class AddTransactionEvent extends TransactionEvent {
  final TransactionModel transaction;
  AddTransactionEvent(this.transaction);
}

class UpdateTransactionEvent extends TransactionEvent {
  final TransactionModel transaction;
  UpdateTransactionEvent(this.transaction);
}

class DeleteTransactionEvent extends TransactionEvent {
  final String id;
  DeleteTransactionEvent(this.id);
}


