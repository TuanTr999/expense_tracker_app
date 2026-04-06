import 'package:expense_tracker_app/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/widgets/transaction_item.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key, required this.transactions});

  final List<TransactionModel> transactions;

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
            return TransactionItem(item: transactions[index]);
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
