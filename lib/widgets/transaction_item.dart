import 'package:expense_tracker_app/models/transaction_model.dart';
import 'package:flutter/material.dart';

import '../utils/format.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({super.key, required this.item});

  final TransactionModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shopping_cart, color: Colors.yellowAccent),
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                TimeOfDay.now().format(context),
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Spacer(),
          Text(
            AppFormat.currencyWithSign(
              item.amount,
              item.type == TransactionType.income,
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: item.type == TransactionType.income
                  ? Colors.green
                  : Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
