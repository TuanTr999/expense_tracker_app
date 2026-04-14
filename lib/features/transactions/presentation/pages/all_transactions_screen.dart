import 'package:expense_tracker_app/core/utils/transaction_group.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_state.dart';
import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/shared/widgets/transaction_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/current_date.dart';
import '../blocs/filter/filter_bloc.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key, required this.transactions});

  final List<TransactionGroup> transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Tất cả giao dịch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Expanded(
        child: Padding(
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
                      child: TransactionItem(
                        item: item,
                        filterType: FilterType.day,
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
