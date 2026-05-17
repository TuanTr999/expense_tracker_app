import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_bloc.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_event.dart';
import 'package:expense_tracker_app/features/transactions/presentation/pages/all_transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expense_tracker_app/core/utils/current_date.dart';
import 'package:expense_tracker_app/core/utils/transaction_util.dart';
import 'package:expense_tracker_app/core/utils/format.dart';

import '../../../../transactions/presentation/blocs/transaction/transaction_state.dart';
import '../../../../transactions/presentation/pages/add_transaction_page.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import '../widgets/budget_card.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_item.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadTransactions(categoryId: null, month: null, year: null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _FilterBar(),
                const SizedBox(height: 20),
                _CustomDatePicker(),
                BlocBuilder<TransactionBloc, TransactionState>(
                  buildWhen: (prev, curr) => prev.filterType != curr.filterType,
                  builder: (context, state) {
                    if (state.filterType == FilterType.all ||
                        state.filterType == FilterType.custom ||
                        state.filterType == FilterType.day) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [BudgetCard(), const SizedBox(height: 20)],
                    );
                  },
                ),

                _SummaryRow(),
                const SizedBox(height: 20),
                _TransactionListHeader(),
                const SizedBox(height: 10),
                _TransactionList(),
              ],
            ),
          ),
          _AddTransactionButton(),
        ],
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<TransactionBloc, TransactionState>(
          buildWhen: (prev, curr) => prev.filterType != curr.filterType,
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FilterItem(title: 'Ngày', type: FilterType.day, state: state),
                _FilterItem(
                  title: 'Tháng',
                  type: FilterType.month,
                  state: state,
                ),
                _FilterItem(title: 'Năm', type: FilterType.year, state: state),
                _FilterItem(
                  title: 'Tất cả',
                  type: FilterType.all,
                  state: state,
                ),
                _FilterItem(
                  title: 'Tùy chỉnh',
                  type: FilterType.custom,
                  state: state,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CustomDatePicker extends StatelessWidget {
  const _CustomDatePicker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      buildWhen: (prev, curr) =>
          prev.filterType != curr.filterType ||
          prev.fromDate != curr.fromDate ||
          prev.toDate != curr.toDate,
      builder: (context, state) {
        if (state.filterType != FilterType.custom) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DatePickerButton(
                  date: state.fromDate,
                  filterType: state.filterType,
                  onPicked: (picked) {
                    context.read<TransactionBloc>().add(
                      ChangeFilterTypeTransaction(
                        FilterType.custom,
                        fromDate: picked,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 15),
                const Text(
                  '-',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 15),
                _DatePickerButton(
                  date: state.toDate,
                  filterType: state.filterType,
                  onPicked: (picked) {
                    context.read<TransactionBloc>().add(
                      ChangeFilterTypeTransaction(
                        FilterType.custom,
                        toDate: picked,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      buildWhen: (prev, curr) =>
          prev.filteredTransactions != curr.filteredTransactions,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Chi tiêu',
                amount: AppFormat.currency(
                  calculateTotalExpense(state.filteredTransactions),
                ),
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SummaryCard(
                title: 'Thu nhập',
                amount: AppFormat.currency(
                  calculateTotalIncome(state.filteredTransactions),
                ),
                color: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TransactionListHeader extends StatelessWidget {
  const _TransactionListHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Danh sách giao dịch',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        BlocBuilder<TransactionBloc, TransactionState>(
          buildWhen: (prev, curr) =>
              prev.groupedTransactions != curr.groupedTransactions,
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context.read<TransactionBloc>(),
                        ),
                        BlocProvider.value(value: context.read<CategoryBloc>()),
                      ],
                      child: AllTransactionsScreen(
                        transactions: state.groupedTransactions,
                      ),
                    ),
                  ),
                );
              },
              child: const Text(
                'Xem tất cả',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TransactionList extends StatelessWidget {
  const _TransactionList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      buildWhen: (prev, curr) =>
          prev.groupedTransactions != curr.groupedTransactions,
      builder: (context, state) {
        return Expanded(
          child: ListView.builder(
            itemCount: state.groupedTransactions.length,
            itemBuilder: (context, index) {
              final group = state.groupedTransactions[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      formatDate(FilterType.day, group.date),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...group.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TransactionItem(transaction: item),
                    ),
                  ),
                ],
              );
            },
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<TransactionBloc>(),
                      ),
                      BlocProvider.value(value: context.read<CategoryBloc>()),
                    ],
                    child: AddTransactionPage(),
                  ),
                ),
              );
            },
            child: const Text(
              'Thêm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
  final TransactionState state;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<TransactionBloc>().add(ChangeFilterTypeTransaction(type));
      },
      child: Text(
        title,
        style: TextStyle(
          color: state.filterType == type ? Colors.black : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DatePickerButton extends StatelessWidget {
  const _DatePickerButton({
    required this.date,
    required this.filterType,
    required this.onPicked,
  });

  final DateTime? date;
  final FilterType filterType;
  final ValueChanged<DateTime> onPicked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) onPicked(picked);
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
            formatDate(filterType, date),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
