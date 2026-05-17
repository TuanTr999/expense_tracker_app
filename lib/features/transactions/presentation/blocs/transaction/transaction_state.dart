import 'package:expense_tracker_app/features/transactions/data/models/transaction_balance_model.dart';
import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';
import 'package:expense_tracker_app/core/utils/transaction_group.dart';
import 'package:expense_tracker_app/core/enums/app_type.dart';

enum FilterType { day, month, year, all, custom }

class TransactionState {
  final List<TransactionModel> allTransactions;
  final List<TransactionModel> filteredTransactions;
  final List<TransactionGroup> groupedTransactions;

  final FilterType filterType;
  final AppType? transactionType;

  final DateTime selectedDate;
  final DateTime? fromDate;
  final DateTime? toDate;

  final BalanceModel? balance;

  final bool reset;

  const TransactionState({
    required this.allTransactions,
    required this.filteredTransactions,
    required this.groupedTransactions,
    required this.filterType,
    this.transactionType,
    required this.selectedDate,
    this.fromDate,
    this.toDate,
    required this.reset,
    this.balance
  });

  TransactionState copyWith({
    List<TransactionModel>? allTransactions,
    List<TransactionModel>? filteredTransactions,
    List<TransactionGroup>? groupedTransactions,
    FilterType? filterType,
    AppType? transactionType,
    DateTime? selectedDate,
    DateTime? fromDate,
    DateTime? toDate,
    bool? reset,
    BalanceModel? balance
  }) {
    return TransactionState(
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      groupedTransactions: groupedTransactions ?? this.groupedTransactions,
      filterType: filterType ?? this.filterType,
      transactionType: transactionType ?? this.transactionType,
      selectedDate: selectedDate ?? this.selectedDate,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      reset: reset ?? this.reset,
      balance: balance ?? this.balance
    );
  }
}