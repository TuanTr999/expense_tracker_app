import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/transaction_model.dart';
import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc()
    : super(
        FilterState(
          type: FilterType.day,
          reset: false,
          selectedDate: DateTime.now(),
          allTransactions: [],
          filteredTransactions: [],
        ),
      ) {
    List<TransactionModel> _filter(
      List<TransactionModel> list,
      FilterType type,
      DateTime date,
    ) {
      switch (type) {
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
          return list;
      }
    }

    on<LoadTransactions>((event, emit) {
      final filtered = _filter(
        event.transactions,
        state.type,
        state.selectedDate,
      );

      emit(state.copyWith(
        allTransactions: event.transactions,
        filteredTransactions: filtered,
      ));
    });

    on<ChangeFilterType>((event, emit) {
      final filtered = _filter(
        state.allTransactions,
        event.type,
        state.selectedDate,
      );
      emit(state.copyWith(type: event.type, filteredTransactions: filtered));
    });

    on<PreviousPressed>((event, emit) {
      final current = state.selectedDate;
      DateTime newDate = current;

      switch (state.type) {
        case FilterType.day:
          newDate = current.subtract(const Duration(days: 1));
          break;

        case FilterType.month:
          newDate = DateTime(current.year, current.month - 1, current.day);
          break;

        case FilterType.year:
          newDate = DateTime(current.year - 1, current.month, current.day);
          break;

        case FilterType.all:
        case FilterType.custom:
          return;
      }

      final filtered = _filter(state.allTransactions, state.type, newDate);

      emit(
        state.copyWith(selectedDate: newDate, reset: true, filteredTransactions: filtered),
      );
    });

    /// 🔹 Bấm tới
    on<NextPressed>((event, emit) {
      final current = state.selectedDate;
      DateTime newDate = current;

      switch (state.type) {
        case FilterType.day:
          newDate = current.add(const Duration(days: 1));
          break;

        case FilterType.month:
          newDate = DateTime(current.year, current.month + 1, current.day);
          break;

        case FilterType.year:
          newDate = DateTime(current.year + 1, current.month, current.day);
          break;

        case FilterType.all:
        case FilterType.custom:
          return;
      }

      final filtered = _filter(state.allTransactions, state.type, newDate);

      emit(
        state.copyWith(selectedDate: newDate, reset: true, filteredTransactions: filtered),
      );
    });

    /// 🔹 Reset về hôm nay
    on<ResetPressed>((event, emit) {
      final now = DateTime.now();

      final filtered = _filter(state.allTransactions, state.type, now);

      emit(state.copyWith(selectedDate: now,reset: false, filteredTransactions: filtered));
    });
  }
}
