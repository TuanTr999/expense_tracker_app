import 'package:expense_tracker_app/core/constants/app_colors.dart';
import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:expense_tracker_app/features/categories/data/models/category_model.dart';
import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_event.dart';
import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/app_type.dart';
import '../../../categories/presentation/blocs/category/category_bloc.dart';
import '../../../categories/presentation/blocs/category/category_state.dart';
import '../blocs/transaction/transaction_event.dart';

class UpdateTransactionPage extends StatefulWidget {
  const UpdateTransactionPage({super.key, required this.currentTransaction});

  final TransactionModel currentTransaction;

  @override
  State<UpdateTransactionPage> createState() => _UpdateTransactionPageState();
}

class _UpdateTransactionPageState extends State<UpdateTransactionPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController tittleController = TextEditingController();

  late final TransactionModel currentTransaction;
  CategoryModel? newCategory;

  @override
  void initState() {
    super.initState();
    currentTransaction = widget.currentTransaction;
    amountController.text = currentTransaction.amount % 1 == 0
        ? currentTransaction.amount.toInt().toString()
        : currentTransaction.amount.toString();
    tittleController.text = currentTransaction.title;
    context.read<CategoryBloc>().add(
      LoadCategoryByTypeEvent(currentTransaction.type),
    );
    newCategory = CategoryModel(
      id: currentTransaction.categoryId,
      name: '',
      icon: '',
      type: currentTransaction.type,
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    tittleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppCircleButton(
              onTap: () {
                Navigator.pop(context);
              },
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.arrow_back_ios),
            ),
            SizedBox(width: 20,),
            Container(
              width: 240,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: currentTransaction.type == AppType.expense
                            ? Colors.red
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Tiền chi',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: currentTransaction.type == AppType.income
                            ? Colors.green
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Tiền thu',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Center(
                    child: Text(
                      'Tiền',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 25),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: amountController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: AppFormat.currency(currentTransaction.amount),
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey, thickness: 1, height: 20),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Center(
                    child: Text(
                      'Ghi chú',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 25),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: tittleController,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: currentTransaction.title,
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey, thickness: 1, height: 20),
            Text(
              'Danh mục',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final categories = state.categories;

                  if (categories.isEmpty) {
                    return const SizedBox();
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final item = categories[index];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            newCategory = item;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: newCategory?.id == item.id
                                ? Colors.blue
                                : Colors.transparent,
                            border: Border.all(
                              color: newCategory?.id == item.id
                                  ? Colors.blue
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/${item.type.name}/${item.icon}',
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: item.id == newCategory?.id
                                        ? Colors.black
                                        : Colors.grey,
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
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final raw = amountController.text.replaceAll(',', '');
              final amount = double.tryParse(raw);

              String error = '';

              if (amountController.text.isEmpty) {
                error = 'Nhập số tiền';
              } else if (amount == null || amount <= 0) {
                error = 'Số tiền không hợp lệ';
              } else if (tittleController.text.isEmpty) {
                error = 'Nhập ghi chú';
              } else if (newCategory == null) {
                error = 'Chọn danh mục';
              }

              if (error.isNotEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error)));
                return;
              }

              final transaction = TransactionModel(
                id: currentTransaction.id,
                title: tittleController.text,
                amount: amount!,
                date: currentTransaction.date,
                type: currentTransaction.type,
                categoryId: newCategory!.id!,
              );

              context.read<TransactionBloc>().add(
                UpdateTransactionEvent(transaction),
              );

              Navigator.pop(context);
            },
            child: Text(
              'Cập nhật',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
