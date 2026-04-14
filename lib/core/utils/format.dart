import 'package:intl/intl.dart';

class AppFormat {
  static String currency(double amount) {
    final formatter = amount % 1 == 0
        ? NumberFormat('#,###', 'vi_VN')
        : NumberFormat('#,###.##', 'vi_VN');

    return '${formatter.format(amount)} VND';
  }

  static String currencyWithSign(double amount, bool isIncome) {
    final formatted = currency(amount);
    return isIncome ? '+$formatted' : '-$formatted';
  }
}