import '../../features/transactions/data/models/transaction_model.dart';

class TransactionGroup {
  final DateTime date;
  final List<TransactionModel> items;

  TransactionGroup({
    required this.date,
    required this.items,
  });
}

List<TransactionGroup> groupByDate(List<TransactionModel> list) {
  final Map<String, List<TransactionModel>> map = {};

  for (final item in list) {
    final key = "${item.date.year}-${item.date.month}-${item.date.day}";

    map.putIfAbsent(key, () => []);
    map[key]!.add(item);
  }

  final groups = map.entries.map((e) {
    final parts = e.key.split('-');

    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );

    return TransactionGroup(
      date: date,
      items: e.value,
    );
  }).toList();

  groups.sort((a, b) => b.date.compareTo(a.date));

  return groups;
}