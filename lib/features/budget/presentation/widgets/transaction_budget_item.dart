import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';
import 'package:expense_tracker_app/features/transactions/presentation/pages/transaction_detail_page.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/app_type.dart';
import '../../../categories/presentation/blocs/category/category_bloc.dart';
import '../../../transactions/presentation/blocs/transaction/transaction_bloc.dart';


class TransactionBudgetItem extends StatelessWidget {
  const TransactionBudgetItem({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Text(
              transaction.title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),

          SizedBox(width: 10,),
          Text(
            AppFormat.currencyWithSign(
              transaction.amount,
              transaction.type == AppType.income,
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: transaction.type == AppType.income
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
