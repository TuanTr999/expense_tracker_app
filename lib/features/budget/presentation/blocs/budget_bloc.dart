import 'package:expense_tracker_app/core/enums/app_status.dart';
import 'package:expense_tracker_app/features/budget/data/repositories/budget_repository.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_event.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transactions/presentation/blocs/transaction/transaction_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetRepository repository;

  BudgetBloc(this.repository)
    : super(
        BudgetState(
          budgets: [],
          budgetsSummary: [],
          type: FilterType.month,
          status: AppStatus.initial,
          selectedDate: DateTime.now(),
          reset: false,
        ),
      ) {
    on<LoadBudget>(_onLoadBudget);
    on<CreateBudget>(_onCreateBudget);
    on<UpdateBudget>(_onUpdateBudget);
    on<DeleteBudget>(_onDeleteBudget);
    on<DeleteAllBudget>(_onDeleteAllBudgets);
    on<ChangeFilterType>(_onChangeFilterType);
    on<PreviousPressedBudget>(_onPreviousPressed);
    on<NextPressedBudget>(_onNextPressed);
    on<ResetPressedBudget>(_onResetPressed);
    on<LoadBudgetSummary>(_onLoadBudgetSummary);
  }

  Future<void> _onLoadBudget(
    LoadBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      final data = await repository.getBudgetAll(
        event.month,
        event.year,
        event.categoryId,
      );

      emit(state.copyWith(budgets: data, status: AppStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onLoadBudgetSummary(
    LoadBudgetSummary event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      final data = await repository.getBudgetSummary(event.month, event.year);
      emit(state.copyWith(budgetsSummary: data, status: AppStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onCreateBudget(
    CreateBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      await repository.createBudget(event.budget);

      final data = await repository.getBudgetSummary(state.selectedDate.month, state.selectedDate.year);

      emit(state.copyWith(status: AppStatus.success, budgetsSummary: data));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onUpdateBudget(
    UpdateBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      await repository.updateBudget(event.budget);

      final data = await repository.getBudgetSummary(state.selectedDate.month, state.selectedDate.year);

      emit(state.copyWith(status: AppStatus.success, budgetsSummary: data));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onDeleteBudget(
    DeleteBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      await repository.deleteBudget(event.id);

      emit(state.copyWith(status: AppStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onChangeFilterType(
    ChangeFilterType event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      state.selectedDate.year == DateTime.now().year &&
              state.selectedDate.month == DateTime.now().month &&
              state.selectedDate.day == DateTime.now().day
          ? emit(
              state.copyWith(
                type: event.type,
                reset: false,
                status: AppStatus.success,
              ),
            )
          : emit(
              state.copyWith(
                type: event.type,
                reset: true,
                status: AppStatus.success,
              ),
            );

      add(
        event.type == FilterType.month
            ? LoadBudgetSummary(
                state.selectedDate.month,
                state.selectedDate.year,
              )
            : LoadBudgetSummary(null, state.selectedDate.year),
      );
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onPreviousPressed(
    PreviousPressedBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      final current = state.selectedDate;
      DateTime newDate = current;

      switch (state.type) {
        case FilterType.month:
          newDate = DateTime(current.year, current.month - 1, current.day);
          break;

        case FilterType.year:
          newDate = DateTime(current.year - 1, current.month, current.day);
          break;

        default:
          return;
      }

      emit(state.copyWith(selectedDate: newDate, reset: true));

      add(
        state.type == FilterType.month
            ? LoadBudgetSummary(newDate.month, newDate.year)
            : LoadBudgetSummary(null, newDate.year),
      );
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onNextPressed(
    NextPressedBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      final current = state.selectedDate;
      DateTime newDate = current;

      switch (state.type) {
        case FilterType.month:
          newDate = DateTime(current.year, current.month + 1, current.day);
          break;

        case FilterType.year:
          newDate = DateTime(current.year + 1, current.month, current.day);
          break;

        default:
          return;
      }

      emit(state.copyWith(selectedDate: newDate, reset: true));

      add(
        state.type == FilterType.month
            ? LoadBudgetSummary(newDate.month, newDate.year)
            : LoadBudgetSummary(null, newDate.year),
      );
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onResetPressed(
    ResetPressedBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      final now = DateTime.now();

      emit(state.copyWith(selectedDate: now, reset: false));

      add(
        state.type == FilterType.month
            ? LoadBudgetSummary(now.month, now.year)
            : LoadBudgetSummary(null, now.year),
      );
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onDeleteAllBudgets(
    DeleteAllBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      await repository.deleteAllBudget();

      emit(state.copyWith(budgetsSummary: [], status: AppStatus.success));

      add(
        state.type == FilterType.month
            ? LoadBudgetSummary(
                state.selectedDate.month,
                state.selectedDate.year,
              )
            : LoadBudgetSummary(null, state.selectedDate.year),
      );
    } catch (e) {
      print(e);

      emit(state.copyWith(status: AppStatus.error));
    }
  }
}
