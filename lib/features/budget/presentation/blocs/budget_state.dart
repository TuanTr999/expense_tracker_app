import 'package:expense_tracker_app/core/enums/app_status.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_model.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_summary_model.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_state.dart';

class BudgetState {
  final List<BudgetModel> budgets;
  final List<BudgetSummaryModel> budgetsSummary;
  final AppStatus? status;
  final FilterType type;
  final bool reset;
  final DateTime selectedDate;


  BudgetState({
    required this.budgets,
    required this.budgetsSummary,
    this.status,
    required this.type,
    required this.reset,
    required this.selectedDate
  });

  BudgetState copyWith({
    List<BudgetModel>? budgets,
    AppStatus? status,
    FilterType? type,
    bool? reset,
    DateTime? selectedDate,
    List<BudgetSummaryModel>? budgetsSummary
  }) {
    return BudgetState(
        budgets: budgets ?? this.budgets,
        budgetsSummary: budgetsSummary ?? this.budgetsSummary,
        status: status ?? this.status,
        type: type ?? this.type,
        reset: reset ?? this.reset,
        selectedDate: selectedDate ?? this.selectedDate
    );
  }
}
