import 'package:expense_tracker_app/presentation/blocs/filter/filter_state.dart';
import 'package:expense_tracker_app/domain/entities/transaction.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/current_date.dart';
import '../../../core/utils/format.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({super.key, required this.item, required this.filterType});

  final TransactionModel item;
  final FilterType filterType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        filterType != FilterType.day
            ? Text(
                formatDate(FilterType.day, item.date),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            : Container(),
        SizedBox(height: 5),
        Container(
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
                    '${item.date.hour}:${item.date.minute}',
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
