import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_model.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_summary_model.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_bloc.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../transactions/presentation/blocs/transaction/transaction_state.dart';
import '../../blocs/budget_state.dart';

class UpdateBudgetScreen extends StatefulWidget {
  const UpdateBudgetScreen({
    super.key,
    required this.budget,
    required this.selectedDate,
  });

  final BudgetSummaryModel budget;
  final DateTime selectedDate;

  @override
  State<UpdateBudgetScreen> createState() => _UpdateBudgetScreenState();
}

class _UpdateBudgetScreenState extends State<UpdateBudgetScreen> {
  TextEditingController textBudgetAmount = TextEditingController();
  String? errorText;
  late BudgetSummaryModel budget;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    budget = widget.budget;
    selectedDate = widget.selectedDate;
    textBudgetAmount.text = widget.budget.budgetAmount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppCircleButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close, size: 30),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/icons/expense/${widget.budget.categoryIcon}',
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.budget.categoryName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SizedBox(width: 60),
                ],
              ),
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
                      DateTime tempDate = selectedDate;

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
                                      setState(() {
                                        selectedDate = tempDate;
                                      });

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

                                initialDateTime: selectedDate,

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
                          '${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',

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
                'Ngân sách',
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
                  child: TextField(
                    controller: textBudgetAmount,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.start,

                    onChanged: (value) {
                      if (value.isNotEmpty && errorText != null) {
                        setState(() {
                          errorText = null;
                        });
                      }
                    },

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),

                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorText: errorText,
                      hintText: 'Vui lòng nhập ngân sách',
                    ),
                  ),
                  // Text(
                  //   AppFormat.currency(widget.budget.budgetAmount),
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  if (textBudgetAmount.text.trim().isEmpty) {
                    setState(() {
                      errorText = 'Vui lòng nhập ngân sách';
                    });
                    return;
                  }

                  final newBudget = BudgetModel(
                    id: budget.budgetId,
                    categoryId: budget.categoryId,
                    amount: double.tryParse(textBudgetAmount.text) ?? 0,
                    month: selectedDate.month,
                    year: selectedDate.year,
                  );

                  final isSameMonth =
                      budget.month == selectedDate.month &&
                      budget.year == selectedDate.year;

                  if (budget.budgetId == 0 || !isSameMonth) {
                    context.read<BudgetBloc>().add(CreateBudget(newBudget));
                  } else {
                    context.read<BudgetBloc>().add(UpdateBudget(newBudget));
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
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

class _BudgetItem extends StatelessWidget {
  const _BudgetItem({required this.budget});

  final BudgetSummaryModel budget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
