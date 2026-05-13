import 'package:expense_tracker_app/core/enums/app_status.dart';
import 'package:expense_tracker_app/core/utils/budget_util.dart';
import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_summary_model.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_bloc.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_event.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_state.dart';
import 'package:expense_tracker_app/features/budget/presentation/pages/budget/all_budgets_screen.dart';
import 'package:expense_tracker_app/features/budget/presentation/pages/budget/budget_app_bar.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    context.read<BudgetBloc>().add(LoadBudgetSummary(now.month, now.year));
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

class _ListBudgetsSummary extends StatelessWidget {
  const _ListBudgetsSummary();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      // buildWhen: (pre, cur) => pre.budgetsSummary != cur.budgetsSummary,
      builder: (context, state) {
        final budgetsSummary = state.budgetsSummary.where((e) {
          return e.budgetAmount != 0;
        }).toList();
        return ListView.separated(
          itemBuilder: (context, index) {
            return _DetailBudgetSummary(budgetsSummary: budgetsSummary[index]);
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
  const _DetailBudgetSummary({required this.budgetsSummary});

  final BudgetSummaryModel budgetsSummary;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
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
                SizedBox(width: 20),
                Text(
                  AppFormat.currency(budgetsSummary.budgetAmount),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                SizedBox(width: 20),
                Text(
                  AppFormat.currency(budgetsSummary.spentAmount),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
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
