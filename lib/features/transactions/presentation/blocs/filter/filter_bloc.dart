import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';
import 'package:expense_tracker_app/core/utils/transaction_group.dart';

import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc()
    : super(
        FilterState(
          filterType: FilterType.day,
          reset: false,
          selectedDate: DateTime.now(),
          allTransactions: [],
          filteredTransactions: [],
          groupedTransactions: [],
          fromDate: null,
          toDate: null,
        ),
      ) {
    List<TransactionModel> _filter(
      List<TransactionModel> list,
      FilterType filterType,
      DateTime date,
      DateTime? from,
      DateTime? to,
    ) {
      switch (filterType) {
        case FilterType.day:
          return list
              .where(
                (t) =>
                    t.date.year == date.year &&
                    t.date.month == date.month &&
                    t.date.day == date.day,
              )
              .toList();

        case FilterType.month:
          return list
              .where(
                (t) => t.date.year == date.year && t.date.month == date.month,
              )
              .toList();

        case FilterType.year:
          return list.where((t) => t.date.year == date.year).toList();

        case FilterType.all:
          return list;

        case FilterType.custom:
          if (from == null && to == null) return list;

          final start = from ?? DateTime(1970);
          final end = to ?? DateTime(2100);

          return list.where((t) {
            return !t.date.isBefore(start) && !t.date.isAfter(end);
          }).toList();
      }
    }

    List<TransactionGroup> _group(List<TransactionModel> list) {
      return groupByDate(list);
    }

    on<SetTransactions>((event, emit) {
      final filtered = _filter(
        event.transactions,
        state.filterType,
        state.selectedDate,
        state.fromDate,
        state.toDate,
      );

      emit(
        state.copyWith(
          allTransactions: event.transactions,
          filteredTransactions: filtered,
          groupedTransactions: _group(filtered),
        ),
      );
    });

    on<ChangeTransactionType>((event, emit) {
      emit(state.copyWith(transactionType: event.transactionType));
    });

    on<ChangeFilterType>((event, emit) {
      final fromDate = event.fromDate ?? state.fromDate;
      final toDate = event.toDate ?? state.toDate;
      final baseDate = state.selectedDate;

      final filtered = _filter(
        state.allTransactions,
        event.filterType,
        baseDate,
        fromDate,
        toDate,
      );
      event.filterType == FilterType.all ||
              event.filterType == FilterType.custom
          ? emit(
              state.copyWith(
                filterType: event.filterType,
                reset: false,
                fromDate: fromDate,
                toDate: toDate,
                filteredTransactions: filtered,
                groupedTransactions: _group(filtered),
              ),
            )
          : state.selectedDate.year == DateTime.now().year &&
                state.selectedDate.month == DateTime.now().month &&
                state.selectedDate.day == DateTime.now().day
          ? emit(
              state.copyWith(
                filterType: event.filterType,
                reset: false,
                fromDate: fromDate,
                toDate: toDate,
                filteredTransactions: filtered,
                groupedTransactions: _group(filtered),
              ),
            )
          : emit(
              state.copyWith(
                filterType: event.filterType,
                fromDate: fromDate,
                reset: true,
                toDate: toDate,
                filteredTransactions: filtered,
                groupedTransactions: _group(filtered),
              ),
            );
    });

    on<PreviousPressed>((event, emit) {
      final current = state.selectedDate;
      DateTime newDate = current;

      switch (state.filterType) {
        case FilterType.day:
          newDate = current.subtract(const Duration(days: 1));
          break;
        case FilterType.month:
          newDate = DateTime(current.year, current.month - 1, current.day);
          break;
        case FilterType.year:
          newDate = DateTime(current.year - 1, current.month, current.day);
          break;
        default:
          return;
      }

      final filtered = _filter(
        state.allTransactions,
        state.filterType,
        newDate,
        state.fromDate,
        state.toDate,
      );

      emit(
        state.copyWith(
          selectedDate: newDate,
          filteredTransactions: filtered,
          groupedTransactions: _group(filtered),
          reset: true,
        ),
      );
    });

    on<NextPressed>((event, emit) {
      final current = state.selectedDate;
      DateTime newDate = current;

      switch (state.filterType) {
        case FilterType.day:
          newDate = current.add(const Duration(days: 1));
          break;
        case FilterType.month:
          newDate = DateTime(current.year, current.month + 1, current.day);
          break;
        case FilterType.year:
          newDate = DateTime(current.year + 1, current.month, current.day);
          break;
        default:
          return;
      }

      final filtered = _filter(
        state.allTransactions,
        state.filterType,
        newDate,
        state.fromDate,
        state.toDate,
      );

      emit(
        state.copyWith(
          selectedDate: newDate,
          filteredTransactions: filtered,
          groupedTransactions: _group(filtered),
          reset: true,
        ),
      );
    });

    on<ResetPressed>((event, emit) {
      final now = DateTime.now();

      final filtered = _filter(
        state.allTransactions,
        state.filterType,
        now,
        state.fromDate,
        state.toDate,
      );

      emit(
        state.copyWith(
          selectedDate: now,
          filteredTransactions: filtered,
          groupedTransactions: _group(filtered),
          reset: false,
        ),
      );
    });
  }
}
