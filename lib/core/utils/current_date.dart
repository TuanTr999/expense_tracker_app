DateTime currentDate(int index){
  final now = DateTime.now();

  switch (index) {
    case 0: // Today
      return DateTime(now.year, now.month, now.day);

    case 1: // Month
      return DateTime(now.year, now.month);

    case 2: // Year
      return DateTime(now.year);

    default:
      return DateTime(0);
  }
}
String currentDateString(int index, DateTime date){
  switch (index) {
    case 0: // Today
      return "${date.day}/${date.month}/${date.year}";

    case 1: // Month
      return "${date.month}/${date.year}";

    case 2: // Year
      return "${date.year}";

    case 3:
      return "Tất cả";

    default:
      return 'Tuỳ chỉnh';
  }
}