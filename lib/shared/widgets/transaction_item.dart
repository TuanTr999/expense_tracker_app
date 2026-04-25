import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_state.dart';
import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';
import 'package:expense_tracker_app/features/transactions/presentation/pages/transaction_detail_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/enums/app_type.dart';
import '../../features/categories/presentation/blocs/category/category_bloc.dart';
import '../../features/transactions/presentation/blocs/transaction/transaction_bloc.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<TransactionBloc>()),
                BlocProvider.value(value: context.read<CategoryBloc>()),
              ],
              child: TransactionDetail(transactionId: transaction.id),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  child: Image.asset(
                    'assets/icons/${transaction.type.name}/${transaction.categoryIcon}',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      (transaction.date.hour != 0)
                          ? Text(
                              '${transaction.date.hour}:${transaction.date.minute}',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
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
          ),
        ],
      ),
    );
  }
}
