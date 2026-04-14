import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_state.dart';
import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/shared/widgets/transaction_item.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key, required this.transactions, required this.filterType});

  final List<TransactionModel> transactions;
  final FilterType filterType;

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
        title: Text('Tất cả giao dịch', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return TransactionItem(item: transactions[index], filterType: filterType);
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
          itemCount: transactions.length,
        ),
      ),
    );
  }
}
