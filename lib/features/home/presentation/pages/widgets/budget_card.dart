import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_bloc.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_event.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_state.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/budget_util.dart';
import '../../../../transactions/presentation/blocs/transaction/transaction_bloc.dart';

class BudgetCard extends StatefulWidget {
  const BudgetCard({super.key});

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  @override
  void initState() {
    super.initState();
    final transState = context.read<TransactionBloc>().state;

    if (transState.filterType == FilterType.year) {
      context.read<BudgetBloc>().add(
        LoadBudgetSummary(null, transState.selectedDate.year),
      );
    } else if (transState.filterType == FilterType.month) {
      context.read<BudgetBloc>().add(
        LoadBudgetSummary(transState.selectedDate.month, transState.selectedDate.year),
      );
    } else {
      context.read<BudgetBloc>().add(
        LoadBudgetSummary(null, null),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listenWhen: (prev, curr) =>
      prev.selectedDate.month != curr.selectedDate.month ||
          prev.selectedDate.year != curr.selectedDate.year ||
          prev.filterType != curr.filterType ||
          prev.allTransactions.length != curr.allTransactions.length,

      listener: (context, state) {

        if (state.filterType == FilterType.year) {
          context.read<BudgetBloc>().add(
            LoadBudgetSummary(null, state.selectedDate.year),
          );
        } else if (state.filterType == FilterType.month) {
          context.read<BudgetBloc>().add(
            LoadBudgetSummary(state.selectedDate.month, state.selectedDate.year),
          );
        } else if (state.filterType == FilterType.day) {
          context.read<BudgetBloc>().add(
            LoadBudgetSummary(state.selectedDate.month, state.selectedDate.year),
          );
        }
      },
      child: BlocBuilder<BudgetBloc, BudgetState>(
        buildWhen: (pre, cur) => pre.budgetsSummary != cur.budgetsSummary,
        builder: (context, state) {
          final totalBudget = calculateTotalBudget(state.budgetsSummary);
          final remaining = calculateTotalRemainingBudget(state.budgetsSummary);
          final spentAmount = calculateTotalSpentAmountBudget(
              state.budgetsSummary);
          final percent = totalBudget == 0
              ? 0.0
              : (spentAmount.abs() / totalBudget * 100);

          return Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: remaining < 0 ? Colors.red : Colors.green,
                      width: 4,
                    ),
                  ),
                  child: Text(
                    '${percent.toStringAsFixed(0)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Ngân sách',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              AppFormat.currency(totalBudget),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            remaining < 0 ? 'Vượt chi' : 'Còn lại',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              AppFormat.currency(remaining.abs()),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
