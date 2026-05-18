import 'package:expense_tracker_app/core/enums/app_status.dart';
import 'package:expense_tracker_app/core/utils/budget_util.dart';
import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_summary_model.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_bloc.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_event.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_state.dart';
import 'package:expense_tracker_app/features/budget/presentation/pages/budget/all_budgets_screen.dart';
import 'package:expense_tracker_app/features/budget/presentation/widgets/budget_app_bar.dart';
import 'package:expense_tracker_app/features/budget/presentation/widgets/transaction_budget_item.dart';
import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_bloc.dart';
import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_event.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/current_date.dart';
import '../../../../transactions/presentation/blocs/transaction/transaction_bloc.dart';
import '../../../../transactions/presentation/blocs/transaction/transaction_event.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<CategoryBloc>().add(LoadCategoryEvent());
    context.read<BudgetBloc>().add(
      LoadBudgetSummary(DateTime.now().month, DateTime.now().year),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: BudgetAppBar(),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          if (state.status == AppStatus.loading && state.budgets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AppStatus.error) {
            return const Center(child: Text('Có lỗi xảy ra'));
          }
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _FilterBar(),
                    const SizedBox(height: 20),
                    _BudgetSummaryCard(state: state),
                    const SizedBox(height: 20),
                    Expanded(child: _ListBudgetsSummary()),
                  ],
                ),
              ),
              _AddTransactionButton(),
            ],
          );
        },
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      // width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<BudgetBloc, BudgetState>(
          buildWhen: (pre, cur) => pre.type != cur.type,
          builder: (context, state) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FilterItem(
                  title: 'Tháng',
                  type: FilterType.month,
                  state: state,
                ),
                SizedBox(width: 40),
                _FilterItem(title: 'Năm', type: FilterType.year, state: state),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FilterItem extends StatelessWidget {
  const _FilterItem({
    required this.title,
    required this.type,
    required this.state,
  });

  final String title;
  final FilterType type;
  final BudgetState state;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<BudgetBloc>().add(ChangeFilterType(type));
      },
      child: Text(
        title,
        style: TextStyle(
          color: state.type == type ? Colors.black : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _BudgetSummaryCard extends StatelessWidget {
  const _BudgetSummaryCard({required this.state});

  final BudgetState state;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(30),
      child: Container(
        color: Colors.white,
        child: BlocBuilder<BudgetBloc, BudgetState>(
          buildWhen: (pre, cur) {
            return pre.budgetsSummary != cur.budgetsSummary;
          },
          builder: (context, state) {
            final totalBudget = calculateTotalBudget(state.budgetsSummary);
            final remaining = calculateTotalRemainingBudget(
              state.budgetsSummary,
            );
            final spentAmount = calculateTotalSpentAmountBudget(
              state.budgetsSummary,
            );
            final percent = totalBudget == 0
                ? 0.0
                : (spentAmount.abs() / totalBudget * 100);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 20,
                    right: 20,
                    bottom: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ngân sách',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            AppFormat.currency(totalBudget),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chi tiêu',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            AppFormat.currency(spentAmount),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            remaining < 0 ? 'Vượt chi' : 'Còn lại',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            AppFormat.currency(remaining),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: remaining < 0 ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 12,
                  color: remaining < 0 ? Colors.red : Colors.green,
                  backgroundColor: remaining >= 0
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ListBudgetsSummary extends StatefulWidget {
  const _ListBudgetsSummary();

  @override
  State<_ListBudgetsSummary> createState() => _ListBudgetsSummaryState();
}

class _ListBudgetsSummaryState extends State<_ListBudgetsSummary> {
  int? expandedCategoryId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, state) {
        final budgetsSummary = state.budgetsSummary.where((e) {
          return e.budgetAmount != 0;
        }).toList();

        return ListView.separated(
          itemBuilder: (context, index) {
            final item = budgetsSummary[index];

            return _DetailBudgetSummary(
              budgetsSummary: item,
              isExpanded: expandedCategoryId == item.categoryId,
              onTap: () {
                final budgetState = context.read<BudgetBloc>().state;

                setState(() {
                  expandedCategoryId =
                  expandedCategoryId == item.categoryId
                      ? null
                      : item.categoryId;
                });

                if (expandedCategoryId == item.categoryId) {
                  context.read<TransactionBloc>().add(
                    LoadBudgetTransactions(
                      categoryId: item.categoryId,
                      month: budgetState.type == FilterType.month
                          ? budgetState.selectedDate.month
                          : null,
                      year: budgetState.selectedDate.year,
                    ),
                  );
                }
              },
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemCount: budgetsSummary.length,
        );
      },
    );
  }
}

class _DetailBudgetSummary extends StatelessWidget {
  const _DetailBudgetSummary({
    required this.budgetsSummary,
    required this.isExpanded,
    required this.onTap,
  });

  final BudgetSummaryModel budgetsSummary;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, transactionState) {
        final groupedTransactions = transactionState.groupedTransactions;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/expense/${budgetsSummary.categoryIcon}',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      budgetsSummary.categoryName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: onTap,
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ngân sách',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      AppFormat.currency(budgetsSummary.budgetAmount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chi tiêu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      AppFormat.currency(budgetsSummary.spentAmount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                if (isExpanded) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 12,
                      right: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: groupedTransactions.isEmpty
                        ? const Text(
                      'Không có giao dịch',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: groupedTransactions.map((group) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatDate(FilterType.day, group.date),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ...group.items.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: TransactionBudgetItem(
                                  transaction: item,
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}



class _AddTransactionButton extends StatelessWidget {
  const _AddTransactionButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 90,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 1,
            ),
            onPressed: () {
              final budgetBloc = context.read<BudgetBloc>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: budgetBloc,
                    child: AllBudgetsScreen(),
                  ),
                ),
              );
            },
            child: const Text(
              'Ngân sách',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
