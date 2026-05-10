import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/current_date.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_event.dart';

class BudgetAppBar extends StatefulWidget implements PreferredSizeWidget {
  BudgetAppBar({super.key});

  @override
  State<BudgetAppBar> createState() => _BudgetAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BudgetAppBarState extends State<BudgetAppBar> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<BudgetBloc>().state;
    return AppBar(
      backgroundColor: Color(0xFFF5F5F5),
      scrolledUnderElevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppCircleButton(
            onTap: () {
              context.read<BudgetBloc>().add(PreviousPressedBudget());
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
                 formatDate(state.type, state.selectedDate),
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
                    context.read<BudgetBloc>().add(ResetPressedBudget());
                  },
                  child: Icon(Icons.refresh),
                ),
              SizedBox(width: 10),
                AppCircleButton(
                  onTap: () {
                    context.read<BudgetBloc>().add(NextPressedBudget());
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
