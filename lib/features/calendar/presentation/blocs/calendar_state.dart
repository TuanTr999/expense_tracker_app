class CalendarState {
  final DateTime selectedDate;
  final bool reset;

  CalendarState({
    required this.selectedDate,
    required this.reset
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    bool? reset
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      reset: reset ?? this.reset
    );
  }
}