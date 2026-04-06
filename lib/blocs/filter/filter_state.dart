import '../../models/transaction_model.dart';
enum FilterType { day, month, year, all, custom }

class FilterState {
  final FilterType type;
  final bool reset;
  final DateTime selectedDate;
  final List<TransactionModel> allTransactions;
  final List<TransactionModel> filteredTransactions;

  FilterState({
    required this.type,
    required this.reset,
    required this.selectedDate,
    required this.allTransactions,
    required this.filteredTransactions,
  });

  FilterState copyWith({
    FilterType? type,
    bool? reset,
    DateTime? selectedDate,
    List<TransactionModel>? allTransactions,
    List<TransactionModel>? filteredTransactions,
  }) {
    return FilterState(
      type: type ?? this.type,
      reset: reset ?? this.reset,
      selectedDate: selectedDate ?? this.selectedDate,
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions:
      filteredTransactions ?? this.filteredTransactions,
    );
  }
}