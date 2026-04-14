import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';

enum FilterType { day, month, year, all, custom }

class FilterState {
  final FilterType filterType;
  final TransactionType? transactionType;
  final bool reset;
  final DateTime selectedDate;
  final List<TransactionModel> allTransactions;
  final List<TransactionModel> filteredTransactions;
  final DateTime? fromDate ;
  final DateTime? toDate ;

  FilterState({
    required this.filterType,
    this.transactionType,
    required this.reset,
    required this.selectedDate,
    required this.allTransactions,
    required this.filteredTransactions,
    this.fromDate,
    this.toDate,
  });

  FilterState copyWith({
    FilterType? filterType,
    TransactionType? transactionType,
    bool? reset,
    DateTime? selectedDate,
    List<TransactionModel>? allTransactions,
    List<TransactionModel>? filteredTransactions,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return FilterState(
      filterType: filterType ?? this.filterType,
      transactionType: transactionType ?? this.transactionType,
      reset: reset ?? this.reset,
      selectedDate: selectedDate ?? this.selectedDate,
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}

