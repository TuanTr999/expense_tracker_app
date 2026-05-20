import 'package:auto_size_text/auto_size_text.dart';
import 'package:expense_tracker_app/core/enums/app_type.dart';
import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:expense_tracker_app/core/utils/transaction_util.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_event.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/calendar_bloc.dart';
import '../blocs/calendar_event.dart';
import '../blocs/calendar_state.dart';
import '../widgets/calendar_app_bar.dart';
import '../widgets/calendar_day_item.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionRepository = context.read<TransactionBloc>().repository;

    final now = DateTime.now();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CalendarBloc(),
        ),

        BlocProvider(
          create: (_) => TransactionBloc(transactionRepository)
            ..add(
              LoadTransactions(
                month: now.month,
                year: now.year,
              ),
            )
            ..add(
              LoadDayTransactions(
                day: now.day,
                month: now.month,
                year: now.year,
              ),
            )
            ..add(
              LoadTransactionBalance(
                null,
                now.month,
                now.year,
              ),
            ),
        ),
      ],

      child: const _CalendarView(),
    );
  }
}

class _CalendarView extends StatelessWidget {
  const _CalendarView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CalendarBloc, CalendarState>(
          listener: (context, state) {
            _reloadCalendarData(context, state);
          },
        ),

        BlocListener<TransactionBloc, TransactionState>(
          listenWhen: (previous, current) {
            return previous.allTransactions.length != current.allTransactions.length;
          },
          listener: (context, transactionState) {
            final calendarState = context.read<CalendarBloc>().state;

            _reloadCalendarData(context, calendarState);
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: const CalendarAppBar(),
        body: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          removeTop: true,
          child: SingleChildScrollView(
            child: Column(
              children: const [
                SizedBox(height: 22),
                _Calendar(),
                SizedBox(height: 22),
                _Statistical(),
                SizedBox(height: 22),
                _TransactionListByDay(),
                SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _reloadCalendarData(
    BuildContext context,
    CalendarState state,
    ) {
  final month = state.selectedMonth;

  context.read<TransactionBloc>().add(
    LoadTransactions(
      month: month.month,
      year: month.year,
    ),
  );

  context.read<TransactionBloc>().add(
    LoadTransactionBalance(
      null,
      month.month,
      month.year,
    ),
  );

  context.read<TransactionBloc>().add(
    LoadDayTransactions(
      day: state.selectedDate.day,
      month: state.selectedDate.month,
      year: state.selectedDate.year,
    ),
  );
}

class _Calendar extends StatelessWidget {
  const _Calendar();

  double calculateDayBalance(
      DateTime date,
      List transactions,
      ) {
    double balance = 0;

    for (final t in transactions) {

      final sameDay =
          t.date.year == date.year &&
              t.date.month == date.month &&
              t.date.day == date.day;

      if (!sameDay) continue;

      if (t.type == AppType.income) {
        balance += t.amount;
      }

      else {
        balance -= t.amount;
      }
    }

    return balance;
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, calendarState) {

        final selectedMonth =
            calendarState.selectedMonth;

        final selectedDate =
            calendarState.selectedDate;

        final firstDayOfMonth = DateTime(
          selectedMonth.year,
          selectedMonth.month,
          1,
        );

        final daysInMonth = DateTime(
          selectedMonth.year,
          selectedMonth.month + 1,
          0,
        ).day;

        final previousMonthDays = DateTime(
          selectedMonth.year,
          selectedMonth.month,
          0,
        ).day;

        final emptyDaysBefore =
            firstDayOfMonth.weekday - 1;

        final totalItems =
            ((emptyDaysBefore + daysInMonth) / 7)
                .ceil() *
                7;

        return BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, transactionState) {

            return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 12),

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),

                padding: const EdgeInsets.all(1),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),

                  child: Column(
                    children: [

                      const Row(
                        children: [
                          _WeekDayItem('T2'),
                          _WeekDayItem('T3'),
                          _WeekDayItem('T4'),
                          _WeekDayItem('T5'),
                          _WeekDayItem('T6'),
                          _WeekDayItem('T7'),
                          _WeekDayItem('CN'),
                        ],
                      ),

                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,

                        child: GridView.builder(
                          shrinkWrap: true,

                          physics:
                          const NeverScrollableScrollPhysics(),

                          padding: EdgeInsets.zero,

                          itemCount: totalItems,

                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 1.2,
                          ),

                          itemBuilder: (context, index) {

                            DateTime date;

                            bool isCurrentMonth;

                            if (index < emptyDaysBefore) {

                              final previousDay =
                                  previousMonthDays -
                                      emptyDaysBefore +
                                      index +
                                      1;

                              date = DateTime(
                                selectedMonth.year,
                                selectedMonth.month - 1,
                                previousDay,
                              );

                              isCurrentMonth = false;
                            }

                            else {

                              final currentDay =
                                  index -
                                      emptyDaysBefore +
                                      1;

                              if (currentDay <= daysInMonth) {

                                date = DateTime(
                                  selectedMonth.year,
                                  selectedMonth.month,
                                  currentDay,
                                );

                                isCurrentMonth = true;
                              }

                              else {

                                final nextMonthDay =
                                    currentDay -
                                        daysInMonth;

                                date = DateTime(
                                  selectedMonth.year,
                                  selectedMonth.month + 1,
                                  nextMonthDay,
                                );

                                isCurrentMonth = false;
                              }
                            }

                            final isSelected =
                                date.day ==
                                    selectedDate.day &&
                                    date.month ==
                                        selectedDate.month &&
                                    date.year ==
                                        selectedDate.year;

                            return CalendarDayItem(
                              date: date,

                              isCurrentMonth:
                              isCurrentMonth,

                              isSelected: isSelected,

                              balance: calculateDayBalance(
                                date,
                                transactionState
                                    .allTransactions,
                              ),

                              onTap: () {

                                context
                                    .read<CalendarBloc>()
                                    .add(
                                  SetCalendarDate(date),
                                );

                                context
                                    .read<TransactionBloc>()
                                    .add(
                                  LoadDayTransactions(
                                    day: date.day,
                                    month: date.month,
                                    year: date.year,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _WeekDayItem extends StatelessWidget {
  const _WeekDayItem(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {

    final isSunday = title == 'CN';

    final isSaturday = title == 'T7';

    return Expanded(
      child: Container(
        height: 32,

        decoration: BoxDecoration(
          color: Colors.white,

          border: Border.all(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),

        child: Center(
          child: Text(
            title,

            style: TextStyle(
              fontWeight: FontWeight.bold,

              color: isSunday
                  ? Colors.red
                  : isSaturday
                  ? Colors.blue
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class _Statistical extends StatelessWidget {
  const _Statistical();

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {

        final balance = state.balance;

        final expense =
        calculateTotalExpense(
          state.allTransactions,
        );

        final income =
        calculateTotalIncome(
          state.allTransactions,
        );

        return Container(
          margin:
          const EdgeInsets.symmetric(horizontal: 12),

          padding: const EdgeInsets.all(4),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            children: [

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,

                children: [

                  _StatItem(
                    widthC:
                    MediaQuery.of(context)
                        .size
                        .width /
                        4,

                    title: 'Thu nhập',

                    value:
                    AppFormat.currency(income),

                    colorC: Colors.green,
                  ),

                  _StatItem(
                    widthC:
                    MediaQuery.of(context)
                        .size
                        .width /
                        4,

                    title: 'Chi tiêu',

                    value:
                    AppFormat.currency(expense),

                    colorC: Colors.red,
                  ),

                  _StatItem(
                    widthC:
                    MediaQuery.of(context)
                        .size
                        .width /
                        4,

                    title: 'Tổng',

                    value: AppFormat.currency(
                      balance?.currentBalance ?? 0,
                    ),

                    colorC:
                    (balance?.currentBalance ?? 0) >=
                        0
                        ? Colors.green
                        : Colors.red,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Divider(height: 1),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,

                children: [

                  _StatItem(
                    widthC:
                    MediaQuery.of(context)
                        .size
                        .width /
                        3,

                    title: 'Số dư đầu kì',

                    value: AppFormat.currency(
                      balance?.previousBalance ?? 0,
                    ),
                  ),

                  _StatItem(
                    widthC:
                    MediaQuery.of(context)
                        .size
                        .width /
                        3,

                    title: 'Số dư',

                    value: AppFormat.currency(
                      balance?.totalBalance ?? 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TransactionListByDay extends StatelessWidget {
  const _TransactionListByDay();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final transactions = state.selectedDayTransactions;

        if (transactions.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Không có giao dịch trong ngày này',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final t = transactions[index];
              final isIncome = t.type == AppType.income;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                  isIncome
                      ? Colors.green.withOpacity(0.12)
                      : Colors.red.withOpacity(0.12),
                  child: Icon(
                    isIncome
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color:
                    isIncome
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                title: Text(
                  t.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${t.date.day}/${t.date.month}/${t.date.year}',
                ),
                trailing: Text(
                  '${isIncome ? '+' : '-'}${AppFormat.currency(t.amount)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                    isIncome
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color? colorC;
  final double? widthC;

  const _StatItem({
    required this.title,
    required this.value,
    this.colorC,
    this.widthC,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: widthC,

      child: Column(
        children: [

          Text(
            title,

            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          AutoSizeText(
            value,

            textAlign: TextAlign.center,

            maxLines: 1,

            minFontSize: 10,

            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorC ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}