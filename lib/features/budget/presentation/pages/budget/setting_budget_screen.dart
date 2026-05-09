import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_bloc.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBudgetScreen extends StatelessWidget {
  const AddBudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppCircleButton(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
              Text(
                'Cài đặt ngân sách',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              AppCircleButton(
                   onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        title: Text(
                          'Xác nhận',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content:
                            Text(
                              'Bạn có chắc chắn muốn xoá hết ngân sách?',
                              style: TextStyle(fontSize: 16),
                            ),
                        actionsPadding:
                        EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(
                                        context,
                                        false,
                                      ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Colors.green,
                                    foregroundColor:
                                    Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Huỷ',
                                    style: TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(
                                        context,
                                        true,
                                      ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Colors.red,
                                    foregroundColor:
                                    Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Xoá',
                                    style: TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    context.read<BudgetBloc>().add(DeleteAllBudget());
                    Navigator.pop(context);
                  }
                },
                child: Icon(Icons.refresh),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
