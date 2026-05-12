import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:expense_tracker_app/core/utils/transaction_group.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/current_date.dart';
import '../../../home/presentation/pages/widgets/transaction_item.dart';
import '../blocs/transaction/transaction_state.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key, required this.transactions});

  final List<TransactionGroup> transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFFF5F5F5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppCircleButton(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close, size: 30),
            ),
            Text(
              'Tất cả giao dịch',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(width: 60,)
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final group = transactions[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    formatDate(FilterType.day, group.date),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...group.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TransactionItem(transaction: item),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
