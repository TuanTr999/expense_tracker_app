import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:expense_tracker_app/core/utils/budget_util.dart';
import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_summary_model.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_bloc.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_event.dart';
import 'package:expense_tracker_app/features/budget/presentation/pages/budget/update_budget_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../transactions/presentation/blocs/transaction/transaction_state.dart';
import '../../blocs/budget_state.dart';

class AllBudgetsScreen extends StatelessWidget {
  const AllBudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      // buildWhen: (pre, cur) => cur.budgets != pre.budgets,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            backgroundColor: Color(0xFFF5F5F5),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppCircleButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close, size: 30),
                ),
                Text(
                  'Ngân sách',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                AppCircleButton(
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Text(
                            'Xác nhận',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            'Bạn có chắc chắn muốn xoá hết ngân sách?',
                            style: TextStyle(fontSize: 16),
                          ),
                          actionsPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Huỷ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Xoá',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      context.read<BudgetBloc>().add(DeleteAllBudget());

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  child: Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          body: Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FilterBar(),
                  const SizedBox(height: 20),
                  Text(
                    'Thời gian',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),

                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          DateTime tempDate = state.selectedDate;

                          return Container(
                            height: 300,
                            color: Colors.white,

                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },

                                        child: const Text(
                                          'Bỏ qua',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),

                                      TextButton(
                                        onPressed: () {
                                          if (state.type == FilterType.month) {
                                            context.read<BudgetBloc>().add(
                                              LoadBudgetSummary(
                                                tempDate.month,
                                                tempDate.year,
                                              ),
                                            );
                                          } else {
                                            context.read<BudgetBloc>().add(
                                              LoadBudgetSummary(
                                                null,
                                                tempDate.year,
                                              ),
                                            );
                                          }

                                          Navigator.pop(context);
                                        },

                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.monthYear,

                                    initialDateTime: state.selectedDate,

                                    onDateTimeChanged: (value) {
                                      tempDate = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },

                    child: Container(
                      height: 60,

                      padding: const EdgeInsets.symmetric(horizontal: 12),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.type == FilterType.month
                                  ? '${state.selectedDate.month.toString().padLeft(2, '0')}/${state.selectedDate.year}'
                                  : '${state.selectedDate.year}',

                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const Icon(Icons.calendar_month, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tổng ngân sách',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        AppFormat.currency(
                          calculateTotalBudget(state.budgetsSummary),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ngân sách theo hạng mục',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.separated(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.budgetsSummary.length,
                        itemBuilder: (context, index) {
                          return _BudgetItem(
                            budget: state.budgetsSummary[index],
                            selectedDate: state.selectedDate,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(height: 3);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BudgetItem extends StatelessWidget {
  const _BudgetItem({required this.budget, required this.selectedDate});

  final BudgetSummaryModel budget;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          builder: (_) => BlocProvider.value(
            value: context.read<BudgetBloc>(),
            child: FractionallySizedBox(
              heightFactor: 0.93,
              child: UpdateBudgetScreen(
                budget: budget,
                selectedDate: selectedDate,
              ),
            ),
          ),
        );
        if (result == true && context.mounted) {
          context.read<BudgetBloc>().add(
            LoadBudgetSummary(selectedDate.month, selectedDate.year),
          );
        }
      },
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: Row(
          children: [
            Image.asset(
              'assets/icons/expense/${budget.categoryIcon}',
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 10),
            Text(
              budget.categoryName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(
              AppFormat.currency(budget.budgetAmount),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.center,
      child: Container(
        height: 50,
        // width: 200,
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
                  _FilterItem(
                    title: 'Năm',
                    type: FilterType.year,
                    state: state,
                  ),
                ],
              );
            },
          ),
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
