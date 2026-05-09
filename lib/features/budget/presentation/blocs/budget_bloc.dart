import 'package:expense_tracker_app/core/enums/app_status.dart';
import 'package:expense_tracker_app/features/budget/data/repositories/budget_repository.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_event.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_state.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetRepository repository;

  BudgetBloc(this.repository)
    : super(
        BudgetState(
          budgets: [],
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
    on<ChangeFilterType>(_onChangeFilterType);
    on<PreviousPressed>(_onPreviousPressed);
    on<NextPressed>(_onNextPressed);
    on<ResetPressed>(_onResetPressed);
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

  Future<void> _onCreateBudget(
    CreateBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      await repository.createBudget(event.budget);

      emit(state.copyWith(status: AppStatus.success));
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

      emit(state.copyWith(status: AppStatus.success));
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
      emit(state.copyWith(status: AppStatus.loading));

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
            ? LoadBudget(
                state.selectedDate.month,
                state.selectedDate.year,
                null,
              )
            : LoadBudget(null, state.selectedDate.year, null),
      );
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onPreviousPressed(
    PreviousPressed event,
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
            ? LoadBudget(newDate.month, newDate.year, null)
            : LoadBudget(null, newDate.year, null),
      );
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onNextPressed(
    NextPressed event,
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
            ? LoadBudget(newDate.month, newDate.year, null)
            : LoadBudget(null, newDate.year, null),
      );
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onResetPressed(
    ResetPressed event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      final now = DateTime.now();

      emit(state.copyWith(selectedDate: now, reset: false));

      add(
        state.type == FilterType.month
            ? LoadBudget(now.month, now.year, null)
            : LoadBudget(null, now.year, null),
      );
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }
}
