import 'package:expense_tracker_app/core/enums/app_type.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_model.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_state.dart';

abstract class BudgetEvent {}

class LoadBudget extends BudgetEvent {
  final int? month;
  final int? year;
  final int? categoryId;

  LoadBudget(this.month, this.year, this.categoryId);
}

class CreateBudget extends BudgetEvent {
  BudgetModel budget;

  CreateBudget(this.budget);
}

class UpdateBudget extends BudgetEvent {
  BudgetModel budget;

  UpdateBudget(this.budget);
}

class DeleteBudget extends BudgetEvent {
  String id;

  DeleteBudget(this.id);
}

class ChangeFilterType extends BudgetEvent {
  FilterType type;

  ChangeFilterType(this.type);
}
