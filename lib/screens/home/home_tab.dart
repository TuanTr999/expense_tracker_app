import 'package:expense_tracker_app/screens/all_transactions_screen.dart';
import 'package:expense_tracker_app/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/widgets/budget_card.dart';
import 'package:expense_tracker_app/widgets/summary_card.dart';
import 'package:expense_tracker_app/widgets/transaction_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/utils/transaction_utill.dart';
import '../../core/utils/format.dart';
import '../../models/transaction_model.dart';

class HomeTab extends StatefulWidget {
  HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selected = 0;
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selected = 0;
                        });
                      },
                      child: Text(
                        'Ngày',
                        style: TextStyle(
                          color: selected == 0 ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selected = 1;
                        });
                      },
                      child: Text(
                        'Tháng',
                        style: TextStyle(
                          color: selected == 1 ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selected = 2;
                        });
                      },
                      child: Text(
                        'Năm',
                        style: TextStyle(
                          color: selected == 2 ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selected = 3;
                        });
                      },
                      child: Text(
                        'Tất cả',
                        style: TextStyle(
                          color: selected == 3 ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selected = 4;
                        });
                      },
                      child: Text(
                        'Tùy chỉnh',
                        style: TextStyle(
                          color: selected == 4 ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            BudgetCard(),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Chi tiêu',
                    amount: AppFormat.currency(
                      calculateTotalExpense(
                        filteredTransactions(selected, transactions),
                      ),
                    ),
                    color: Colors.red,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: SummaryCard(
                    title: 'Thu nhập',
                    amount: AppFormat.currency(
                      calculateTotalIncome(
                        filteredTransactions(selected, transactions),
                      ),
                    ),
                    color: Colors.green,
                  ),
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllTransactionsScreen(
                          transactions: filteredTransactions(
                            selected,
                            transactions,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Xem tất cả',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                itemCount: filteredTransactions(selected, transactions).length,
                itemBuilder: (context, index) {
                  return TransactionItem(
                    item: filteredTransactions(selected, transactions)[index],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
