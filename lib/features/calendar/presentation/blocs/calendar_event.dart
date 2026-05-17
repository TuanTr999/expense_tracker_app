abstract class CalendarEvent {}


class NextCalendarMonth extends CalendarEvent {}

class PreviousCalendarMonth extends CalendarEvent {}

class ResetCalendarMonth extends CalendarEvent {}

class SetCalendarDate extends CalendarEvent {
  final DateTime date;

  SetCalendarDate(this.date);
}