import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:expense_tracker_app/core/utils/current_date.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/transactions/presentation/blocs/transaction/transaction_state.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<TransactionBloc>().state;
    final currentDate = state.selectedDate;
    return AppBar(
      backgroundColor: Color(0xFFF5F5F5),
      scrolledUnderElevation: 0,
      title: Row(
        mainAxisAlignment:
            (state.filterType != FilterType.all &&
                state.filterType != FilterType.custom)
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          if (state.filterType != FilterType.all &&
              state.filterType != FilterType.custom)
            AppCircleButton(
              onTap: () {
                context.read<TransactionBloc>().add(PreviousDate());
              },
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.arrow_back_ios),
            ),
          Padding(
            padding: (!state.reset)
                ? EdgeInsets.zero
                : EdgeInsets.only(left: 50),
            child: Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  state.filterType != FilterType.custom
                      ? formatDate(state.filterType, currentDate)
                      : "Tùy chỉnh",
                  style: TextStyle(
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
                    context.read<TransactionBloc>().add(ResetFilter());
                  },
                  child: Icon(Icons.refresh),
                ),
              SizedBox(width: 10),
              if (state.filterType != FilterType.all &&
                  state.filterType != FilterType.custom)
                AppCircleButton(
                  onTap: () {
                    context.read<TransactionBloc>().add(NextDate());
                  },
                  child: Icon(Icons.arrow_forward_ios),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
