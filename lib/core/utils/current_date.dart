import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_state.dart';

String formatDate(FilterType type, DateTime? date) {
  if (date == null) return "";
  switch (type) {
    case FilterType.day:
    case FilterType.custom:
      return "${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}";

    case FilterType.month:
      return "${_twoDigits(date.month)}/${date.year}";

    case FilterType.year:
      return "${date.year}";

    case FilterType.all:
      return "Tất cả";

    default:
      return "${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}";
  }
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}
