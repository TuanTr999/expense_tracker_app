import 'package:flutter_bloc/flutter_bloc.dart';

import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc()
      : super(
    CalendarState(
      selectedDate: DateTime.now(),
      reset: false
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
    final current = state.selectedDate;

    emit(
      state.copyWith(
        selectedDate: DateTime(
          current.year,
          current.month + 1,
          1,
        ),
        reset: true
      ),
    );
  }

  void _previousMonth(
      PreviousCalendarMonth event,
      Emitter<CalendarState> emit,
      ) {
    final current = state.selectedDate;

    emit(
      state.copyWith(
        selectedDate: DateTime(
          current.year,
          current.month - 1,
          1,
        ),
        reset: true
      ),
    );
  }

  void _resetMonth(
      ResetCalendarMonth event,
      Emitter<CalendarState> emit,
      ) {
    emit(
      state.copyWith(
        selectedDate: DateTime.now(),
        reset: false
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