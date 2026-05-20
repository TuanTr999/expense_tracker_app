class CalendarState {
  final DateTime selectedDate;
  final DateTime selectedMonth;
  final bool reset;

  CalendarState({
    required this.selectedDate,
    required this.selectedMonth,
    required this.reset
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    DateTime? selectedMonth,
    bool? reset
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
        selectedMonth: selectedMonth ?? this.selectedMonth,
      reset: reset ?? this.reset
    );
  }
}