import 'package:auto_size_text/auto_size_text.dart';
import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:flutter/material.dart';

class CalendarDayItem extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final double balance;
  final VoidCallback onTap;
  final bool isSelected;

  const CalendarDayItem({
    super.key,
    required this.date,
    required this.isCurrentMonth,
    required this.balance,
    required this.onTap,
    required this.isSelected
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final isToday =
        date.day == now.day && date.month == now.month && date.year == now.year;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(1),

        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFF3E0)
              : isToday
              ? Colors.orangeAccent
              : isCurrentMonth
              ? Colors.white
              : Colors.grey.shade400,

          border: Border.all(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,

              child: Text(
                '${date.day}',

                style: TextStyle(
                  fontSize: 12,

                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,

                  color: date.weekday == 6
                      ? Colors.blue
                      : date.weekday == 7
                      ? Colors.red
                      : Colors.black,
                ),
              ),
            ),

            balance < 0 ? Spacer() : SizedBox.shrink(),

            if (balance != 0)
              SizedBox(
                width: double.infinity,

                child: AutoSizeText(
                  AppFormat.currencyNoVND(balance.abs()),

                  textAlign: TextAlign.center,

                  maxLines: 1,

                  minFontSize: 4,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: balance < 0 ? Colors.red : Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );

  }
}
