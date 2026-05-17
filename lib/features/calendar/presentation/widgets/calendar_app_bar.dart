import 'package:expense_tracker_app/features/calendar/presentation/blocs/calendar_event.dart';
import 'package:expense_tracker_app/features/calendar/presentation/blocs/calendar_state.dart';
import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_icon.dart';
import '../../../../core/utils/current_date.dart';
import '../../../transactions/presentation/blocs/transaction/transaction_bloc.dart';
import '../../../transactions/presentation/blocs/transaction/transaction_event.dart';
import '../../../transactions/presentation/blocs/transaction/transaction_state.dart';
import '../blocs/calendar_bloc.dart';

class CalendarAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CalendarAppBar({super.key});

  @override
  State<CalendarAppBar> createState() => _CalendarAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CalendarAppBarState extends State<CalendarAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      buildWhen: (prev, curr) => prev.selectedDate != curr.selectedDate,
      builder: (context, state) {
        final currentDate = state.selectedDate;
        return AppBar(
          backgroundColor: const Color(0xFFF5F5F5),
          scrolledUnderElevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppCircleButton(
                onTap: () {
                  context.read<CalendarBloc>().add(PreviousCalendarMonth());

                },
                padding: const EdgeInsets.only(left: 8),
                child: const Icon(Icons.arrow_back_ios),
              ),
              Padding(
                padding: (!state.reset)
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(left: 50),
                child: Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      formatDate(FilterType.month, currentDate),

                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  if (state.reset)
                    AppCircleButton(
                      onTap: () {
                        context.read<CalendarBloc>().add(ResetCalendarMonth());
                      },
                      child: const Icon(Icons.refresh),
                    ),
                  const SizedBox(width: 10),
                  AppCircleButton(
                    onTap: () {
                      context.read<CalendarBloc>().add(NextCalendarMonth());
                    },
                    child: const Icon(Icons.arrow_forward_ios),
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
