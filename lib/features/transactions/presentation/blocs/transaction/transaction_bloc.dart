import 'package:expense_tracker_app/features/transactions/data/models/transaction_balance_model.dart';
import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_event.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/transaction_group.dart';
import '../../../data/repositories/transaction_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc(this.repository)
    : super(
        TransactionState(
          allTransactions: [],
          filteredTransactions: [],
          groupedTransactions: [],
          selectedDayTransactions: [],
          filterType: FilterType.day,
          selectedDate: DateTime.now(),
          reset: false,
        ),
      ) {
    on<LoadTransactions>(_load);
    on<AddTransaction>(_add);
    on<UpdateTransaction>(_update);
    on<DeleteTransaction>(_delete);

    on<ChangeFilterTypeTransaction>(_changeFilter);
    on<SetSelectedDate>(_setDate);
    on<NextDate>(_next);
    on<PreviousDate>(_prev);
    on<ResetFilter>(_reset);
    on<LoadTransactionBalance>(_loadTransactionBalance);
    on<LoadBudgetTransactions>(_loadBudgetTransactions);
    on<LoadDayTransactions>(_loadDayTransactions);
  }

  // =====================
  // CRUD
  // =====================

  Future<void> _load(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    final data = await repository.getTransactions(categoryId: event.categoryId ,day: event.day,month: event.month, year: event.year);

    final newState = state.copyWith(allTransactions: data);

    emit(_applyFilter(newState));
  }

  Future<void> _add(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    await repository.addTransaction(event.transaction);

    final data = await repository.getTransactions();

    emit(_applyFilter(
      state.copyWith(allTransactions: data),
    ));

  }

  Future<void> _update(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    await repository.updateTransaction(event.transaction);

    final data = await repository.getTransactions();

    emit(_applyFilter(
      state.copyWith(allTransactions: data),
    ));
  }

  Future<void> _delete(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    await repository.deleteTransaction(event.id);

    final data = await repository.getTransactions();

    emit(_applyFilter(
      state.copyWith(allTransactions: data),
    ));
  }

  TransactionState _applyFilter(TransactionState s) {
    final list = s.allTransactions;

    List<TransactionModel> filtered;

    switch (s.filterType) {
      case FilterType.day:
        filtered = list
            .where(
              (t) =>
                  t.date.year == s.selectedDate.year &&
                  t.date.month == s.selectedDate.month &&
                  t.date.day == s.selectedDate.day,
            )
            .toList();
        break;

      case FilterType.month:
        filtered = list
            .where(
              (t) =>
                  t.date.year == s.selectedDate.year &&
                  t.date.month == s.selectedDate.month,
            )
            .toList();
        break;

      case FilterType.year:
        filtered = list
            .where((t) => t.date.year == s.selectedDate.year)
            .toList();
        break;

      case FilterType.all:
        filtered = list;
        break;

      case FilterType.custom:
        final start = s.fromDate ?? DateTime(1970);
        final end = s.toDate ?? DateTime(2100);

        filtered = list
            .where((t) => !t.date.isBefore(start) && !t.date.isAfter(end))
            .toList();
        break;
    }

    final grouped = groupByDate(filtered);

    return s.copyWith(
      filteredTransactions: filtered,
      groupedTransactions: grouped,
    );
  }

  void _changeFilter(
    ChangeFilterTypeTransaction event,
    Emitter<TransactionState> emit,
  ) {
    final newState =
        event.filterType == FilterType.all ||
            event.filterType == FilterType.custom ||
            state.selectedDate.day == DateTime.now().day &&
            state.selectedDate.month == DateTime.now().month &&
            state.selectedDate.year == DateTime.now().year
        ? state.copyWith(
            filterType: event.filterType,
            fromDate: event.fromDate ?? state.fromDate,
            toDate: event.toDate ?? state.toDate,
            reset: false,
          )
        : state.copyWith(
            filterType: event.filterType,
            fromDate: event.fromDate ?? state.fromDate,
            toDate: event.toDate ?? state.toDate,
            reset: true,
          );

    emit(_applyFilter(newState));
  }

  void _setDate(SetSelectedDate event, Emitter<TransactionState> emit) {
    final newState = state.copyWith(selectedDate: event.date);
    emit(_applyFilter(newState));
  }

  void _next(NextDate event, Emitter<TransactionState> emit) {
    DateTime next = state.selectedDate;

    if (state.filterType == FilterType.day) {
      next = next.add(const Duration(days: 1));
    } else if (state.filterType == FilterType.month) {
      next = DateTime(next.year, next.month + 1, next.day);
    } else if (state.filterType == FilterType.year) {
      next = DateTime(next.year + 1, next.month, next.day);
    }

    emit(_applyFilter(state.copyWith(selectedDate: next, reset: true)));
  }

  void _prev(PreviousDate event, Emitter<TransactionState> emit) {
    DateTime prev = state.selectedDate;

    if (state.filterType == FilterType.day) {
      prev = prev.subtract(const Duration(days: 1));
    } else if (state.filterType == FilterType.month) {
      prev = DateTime(prev.year, prev.month - 1, prev.day);
    } else if (state.filterType == FilterType.year) {
      prev = DateTime(prev.year - 1, prev.month, prev.day);
    }

    emit(_applyFilter(state.copyWith(selectedDate: prev, reset: true)));
  }

  void _reset(ResetFilter event, Emitter<TransactionState> emit) {
    final newState = state.copyWith(selectedDate: DateTime.now(), reset: false);

    emit(_applyFilter(newState));
  }

  void _loadTransactionBalance(LoadTransactionBalance event, Emitter<TransactionState> emit) async{
    BalanceModel balanceModel = await repository.getTransactionsBalance(day: event.day,month: event.month, year: event.year);
    emit(state.copyWith(balance: balanceModel));
  }

  Future<void> _loadBudgetTransactions(
      LoadBudgetTransactions event,
      Emitter<TransactionState> emit,
      ) async {
    final data = await repository.getTransactions(
      categoryId: event.categoryId,
      month: event.month,
      year: event.year,
    );

    emit(
      state.copyWith(
        allTransactions: data,
        filteredTransactions: data,
        groupedTransactions: groupByDate(data),
      ),
    );
  }

  Future<void> _loadDayTransactions(
      LoadDayTransactions event,
      Emitter<TransactionState> emit,
      ) async {
    final data = await repository.getTransactions(
      day: event.day,
      month: event.month,
      year: event.year,
    );

    emit(
      state.copyWith(
        selectedDayTransactions: data,
      ),
    );
  }
}
