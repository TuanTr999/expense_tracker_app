import '/models/transaction_model.dart';
import 'filter_state.dart';

abstract class FilterEvent {}

class PreviousPressed extends FilterEvent {}
class NextPressed extends FilterEvent {}
class ResetPressed extends FilterEvent {}

class ChangeFilterType extends FilterEvent {
  final FilterType type;
  final DateTime? fromDate;
  final DateTime? toDate;

  ChangeFilterType(
      this.type, {
        this.fromDate,
        this.toDate,
      });
}

class LoadTransactions extends FilterEvent {
  final List<TransactionModel> transactions;

  LoadTransactions(this.transactions);
}