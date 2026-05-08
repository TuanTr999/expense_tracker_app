import 'package:expense_tracker_app/features/budget/data/datasources/budget_remote_datasource.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_model.dart';
import 'package:expense_tracker_app/features/budget/data/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDatasource remote;

  BudgetRepositoryImpl(this.remote);

  @override
  Future<void> createBudget(BudgetModel budget) {
    return remote.createBudget(budget);
  }

  @override
  Future<void> deleteBudget(String id) {
    return remote.deleteBudget(id);
  }

  // @override
  // Future<List<BudgetModel>> getBudgetById(int id) {
  //   return remote.getBudgetById(id);
  // }

  @override
  Future<void> updateBudget(BudgetModel budget) {
    return remote.updateBudget(budget);
  }

  @override
  Future<List<BudgetModel>> getBudgetAll(
    int? month,
    int? year,
    int? categoryId,
  ) {
    return remote.getBudgetAll(month, year, categoryId);
  }
}
