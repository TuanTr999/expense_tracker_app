import 'package:expense_tracker_app/blocs/filter/filter_state.dart';
import 'package:expense_tracker_app/screens/all_transactions_screen.dart';
import 'package:expense_tracker_app/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/widgets/budget_card.dart';
import 'package:expense_tracker_app/widgets/summary_card.dart';
import 'package:expense_tracker_app/widgets/transaction_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/filter/filter_bloc.dart';
import '../../blocs/filter/filter_event.dart';
import '../../core/utils/transaction_util.dart';
import '../../core/utils/format.dart';
import '../../models/transaction_model.dart';

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
    context.read<FilterBloc>().add(
      LoadTransactions(transactions),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: CustomAppBar(selected: selected,),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    filterItem('Ngày', FilterType.day),
                    filterItem('Tháng', FilterType.month),
                    filterItem('Năm', FilterType.year),
                    filterItem('Tất cả', FilterType.all),
                    filterItem('Tùy chỉnh', FilterType.custom)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
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
                              transactions: state.filteredTransactions,
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
                        item: state.filteredTransactions[index],
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

  Widget filterItem(String title, FilterType type) {
    final state = context.watch<FilterBloc>().state;

    return InkWell(
      onTap: () {
        context.read<FilterBloc>().add(
          ChangeFilterType(type),
        );
      },
      child: Text(
        title,
        style: TextStyle(
          color: state.type == type
              ? Colors.black
              : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

