
import 'package:expense_tracker_app/blocs/filter/filter_state.dart';

String formatDate(FilterType type, DateTime date) {
  switch (type) {
    case FilterType.day:
      return "${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}";

    case FilterType.month:
      return "${_twoDigits(date.month)}/${date.year}";

    case FilterType.year:
      return "${date.year}";

    case FilterType.all:
      return "Tất cả";

    default:
      return "Tuỳ chỉnh";
  }
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}
