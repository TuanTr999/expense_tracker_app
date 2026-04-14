import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_state.dart';
import 'package:expense_tracker_app/features/transactions/presentation/pages/all_transactions_screen.dart';
import 'package:expense_tracker_app/shared/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/shared/widgets/budget_card.dart';
import 'package:expense_tracker_app/shared/widgets/summary_card.dart';
import 'package:expense_tracker_app/shared/widgets/transaction_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_bloc.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_event.dart';
import 'package:expense_tracker_app/core/utils/current_date.dart';
import 'package:expense_tracker_app/core/utils/transaction_util.dart';
import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:expense_tracker_app/features/transactions/domain/entities/transaction_model.dart';

class HomeTab extends StatefulWidget {
  HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<TransactionModel> transactions = [
    TransactionModel(
      id: '1',
      title: 'Ăn sáng',
      image: '',
      amount: 30000,
      date: DateTime(2026, 4, 8, 15, 30, 20),
      type: TransactionType.expense,
    ),
    TransactionModel(
      id: '2',
      title: 'Lương',
      image: '',
      amount: 5000000,
      date: DateTime(2026, 4, 9, 12, 15, 0),
      type: TransactionType.income,
    ),
  ];

  @override
  void initState() {
    super.initState();
    context.read<FilterBloc>().add(LoadTransactions(transactions));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        filterItem('Ngày', FilterType.day, state),
                        filterItem('Tháng', FilterType.month, state),
                        filterItem('Năm', FilterType.year, state),
                        filterItem('Tất cả', FilterType.all, state),
                        filterItem('Tùy chỉnh', FilterType.custom, state),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            BlocBuilder<FilterBloc, FilterState>(
              builder: (context, state) {
                if (state.type != FilterType.custom) {
                  return Container();
                }
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            final fromDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );

                            if (fromDate != null) {
                              context.read<FilterBloc>().add(
                                ChangeFilterType(
                                  FilterType.custom,
                                  fromDate: fromDate,
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 110,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                formatDate(state.type, state.fromDate),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          '-',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 15),
                        InkWell(
                          onTap: () async {
                            final toDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );

                            if (toDate != null) {
                              context.read<FilterBloc>().add(
                                ChangeFilterType(
                                  FilterType.custom,
                                  toDate: toDate,
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 110,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                formatDate(state.type, state.toDate),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
            BudgetCard(),
            SizedBox(height: 20),
            Row(
              children: [
                BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, state) {
                    return Expanded(
                      child: SummaryCard(
                        title: 'Chi tiêu',
                        amount: AppFormat.currency(
                          calculateTotalExpense(state.filteredTransactions),
                        ),
                        color: Colors.red,
                      ),
                    );
                  },
                ),
                SizedBox(width: 20),
                BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, state) {
                    return Expanded(
                      child: SummaryCard(
                        title: 'Thu nhập',
                        amount: AppFormat.currency(
                          calculateTotalIncome(state.filteredTransactions),
                        ),
                        color: Colors.green,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách giao dịch',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllTransactionsScreen(
                              transactions: state.filteredTransactions, filterType: state.type,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Xem tất cả',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            BlocBuilder<FilterBloc, FilterState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: state.filteredTransactions.length,
                    itemBuilder: (context, index) {
                      return TransactionItem(
                        item: state.filteredTransactions[index],filterType: state.type,
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget filterItem(String title, FilterType type, FilterState state) {
    return InkWell(
      onTap: () {
        context.read<FilterBloc>().add(ChangeFilterType(type));
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
