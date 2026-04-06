import 'package:expense_tracker_app/blocs/filter/filter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/filter/filter_bloc.dart';
import '../core/utils/current_date.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FilterBloc>().state;
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 4),
                ),
                child: Text('0%'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Ngân sách',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '100.000 VND',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        'Vượt chi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '100.000 VND',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 22.5,
            right: 10,
            child: state.type != FilterType.custom
                ? Text(
                    formatDate(state.type, state.selectedDate),
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  )
                : (state.fromDate == null || state.toDate == null)
                ? SizedBox()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formatDate(state.type, state.fromDate!),
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                      SizedBox(height: 15),
                      Text(
                        formatDate(state.type, state.toDate!),
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
