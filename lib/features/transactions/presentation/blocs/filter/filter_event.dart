import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';
import '../../../../../core/enums/app_type.dart';
import 'filter_state.dart';

abstract class FilterEvent {}

class PreviousPressed extends FilterEvent {}

class NextPressed extends FilterEvent {}

class ResetPressed extends FilterEvent {}

class ChangeFilterType extends FilterEvent {
  final FilterType filterType;
  final DateTime? fromDate;
  final DateTime? toDate;

  ChangeFilterType(this.filterType, {this.fromDate, this.toDate});
}

class ChangeTransactionType extends FilterEvent {
  final AppType? transactionType;

  ChangeTransactionType({this.transactionType});
}

class SetTransactions extends FilterEvent {
  final List<TransactionModel> transactions;

  SetTransactions(this.transactions);
}
