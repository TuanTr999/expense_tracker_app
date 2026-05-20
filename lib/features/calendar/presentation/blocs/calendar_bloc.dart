import 'package:flutter_bloc/flutter_bloc.dart';

import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc()
      : super(
    CalendarState(
      selectedMonth: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      ),
      selectedDate: DateTime.now(),
      reset: false,
    ),
  ) {
    on<NextCalendarMonth>(_nextMonth);
    on<PreviousCalendarMonth>(_previousMonth);
    on<ResetCalendarMonth>(_resetMonth);
    on<SetCalendarDate>(_setDate);
  }

  void _nextMonth(
      NextCalendarMonth event,
      Emitter<CalendarState> emit,
      ) {
    final current = state.selectedMonth;
    final nextMonth = DateTime(current.year, current.month + 1, 1);

    emit(
      state.copyWith(
        selectedMonth: nextMonth,
        selectedDate: nextMonth,
        reset: true,
      ),
    );
  }

  void _previousMonth(
      PreviousCalendarMonth event,
      Emitter<CalendarState> emit,
      ) {
    final current = state.selectedMonth;
    final previousMonth = DateTime(current.year, current.month - 1, 1);

    emit(
      state.copyWith(
        selectedMonth: previousMonth,
        selectedDate: previousMonth,
        reset: true,
      ),
    );
  }

  void _resetMonth(
      ResetCalendarMonth event,
      Emitter<CalendarState> emit,
      ) {
    final now = DateTime.now();

    emit(
      state.copyWith(
        selectedMonth: DateTime(now.year, now.month, 1),
        selectedDate: now,
        reset: false,
      ),
    );
  }

  void _setDate(
      SetCalendarDate event,
      Emitter<CalendarState> emit,
      ) {
    emit(
      state.copyWith(
        selectedDate: event.date,
      ),
    );
  }
}