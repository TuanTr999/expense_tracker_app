import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expense_tracker_app/core/constants/app_colors.dart';
import 'package:expense_tracker_app/core/enums/app_status.dart';
import 'package:expense_tracker_app/features/categories/data/models/category_model.dart';
import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_event.dart';
import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_state.dart';
import 'package:expense_tracker_app/features/categories/presentation/pages/all_category.dart';
import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_icon.dart';
import '../../../../core/enums/app_type.dart';
import '../../../../core/utils/current_date.dart';
import '../../../categories/presentation/blocs/category/category_bloc.dart';
import '../../../wallet/data/models/wallet_model.dart';
import '../../../wallet/presentation/blocs/wallet_bloc.dart';
import '../../../wallet/presentation/blocs/wallet_event.dart';
import '../../../wallet/presentation/blocs/wallet_state.dart';
import '../blocs/transaction/transaction_event.dart';
import '../blocs/transaction/transaction_state.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController tittleController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  AppType? type;
  CategoryModel? selectedCategory;
  WalletModel? selectedWallet;

  @override
  void initState() {
    super.initState();

    type = AppType.expense;

    context.read<CategoryBloc>().add(LoadCategoryByTypeEvent(AppType.expense));
    context.read<WalletBloc>().add(LoadWalletsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppCircleButton(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close, size: 30),
            ),
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
                    InkWell(
                      onTap: () {
                        setState(() {
                          type = AppType.expense;
                          selectedCategory = null;
                        });

                        context.read<CategoryBloc>().add(
                          LoadCategoryByTypeEvent(AppType.expense),
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: type == AppType.expense
                              ? Colors.red
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(18),
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
                    ),

                    InkWell(
                      onTap: () {
                        setState(() {
                          type = AppType.income;
                          selectedCategory = null;
                        });

                        context.read<CategoryBloc>().add(
                          LoadCategoryByTypeEvent(AppType.income),
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: type == AppType.income
                              ? Colors.green
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(18),
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
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<CategoryBloc>()),
                        BlocProvider.value(
                          value: context.read<TransactionBloc>(),
                        ),
                      ],
                      child: AllCategory(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
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
                  width: 110,
                  child: Center(
                    child: Text(
                      'Ngày',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      DateTime tempDate = selectedDate;

                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        builder: (sheetContext) {
                          return SizedBox(
                            height: 300,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(sheetContext);
                                        },

                                        child: const Text(
                                          'Bỏ qua',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),

                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedDate = tempDate;
                                          });

                                          Navigator.pop(sheetContext);
                                        },

                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.date,

                                    initialDateTime: selectedDate,

                                    minimumDate: DateTime(2020),
                                    maximumDate: DateTime(2100),

                                    onDateTimeChanged: (value) {
                                      tempDate = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 110,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          formatDate(FilterType.day, selectedDate),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
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
                  width: 110,
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
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: amountController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
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
                  width: 110,
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
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: tittleController,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Ghi chú',
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
                const SizedBox(
                  width: 110,
                  child: Center(
                    child: Text(
                      'Danh mục',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 25),

                Expanded(
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state.status == AppStatus.loading) {
                        return const SizedBox(
                          height: 40,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final categories = state.categories;

                      if (categories.isEmpty) {
                        return Container(
                          height: 58,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Không có danh mục',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      }

                      return DropdownButtonHideUnderline(
                        child: DropdownButton2<CategoryModel>(
                          isExpanded: true,

                          valueListenable: ValueNotifier(selectedCategory),

                          hint: const Text(
                            'Chọn danh mục',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),

                          items: categories.map<DropdownItem<CategoryModel>>((
                            item,
                          ) {
                            final isSelected = selectedCategory?.id == item.id;

                            return DropdownItem<CategoryModel>(
                              value: item,
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    padding: const EdgeInsets.all(8),
                                    child: Image.asset(
                                      'assets/icons/${item.type.name}/${item.icon}',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),

                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },

                          buttonStyleData: ButtonStyleData(
                            height: 58,
                            padding: const EdgeInsets.symmetric(horizontal: 14),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(18),

                              border: Border.all(color: Colors.grey.shade200),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),

                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),

                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 300,

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),

                            elevation: 4,
                          ),

                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey, thickness: 1, height: 20),

            Row(
              children: [
                const SizedBox(
                  width: 110,
                  child: Center(
                    child: Text(
                      'Nguồn tiền',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 25),

                Expanded(
                  child: BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, state) {
                      if (state.status == AppStatus.loading) {
                        return const SizedBox(
                          height: 40,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final wallets = state.wallets;

                      if (wallets.isEmpty) {
                        return Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Text(
                            'Không có nguồn tiền',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      }

                      return DropdownButtonHideUnderline(
                        child: DropdownButton2<WalletModel>(
                          isExpanded: true,

                          valueListenable: ValueNotifier(selectedWallet),

                          hint: const Text(
                            'Chọn nguồn tiền',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),

                          items: wallets.map<DropdownItem<WalletModel>>((item) {
                            final isSelected = selectedWallet?.id == item.id;

                            return DropdownItem<WalletModel>(
                              value: item,
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    padding: const EdgeInsets.all(8),
                                    child: Image.asset(
                                      'assets/icons/wallet/${item.icon}',
                                      errorBuilder: (_, __, ___) {
                                        return const Icon(
                                          Icons.account_balance_wallet_rounded,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: Text(
                                      item.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),

                          onChanged: (value) {
                            setState(() {
                              selectedWallet = value;
                            });
                          },

                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),

                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),

                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 4,
                          ),

                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
              } else if (type == null) {
                error = 'Chọn loại giao dịch';
              } else if (selectedCategory == null) {
                error = 'Chọn danh mục';
              } else if (selectedWallet == null) {
                error = 'Chọn nguồn tiền';
              }

              if (error.isNotEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error)));
                return;
              }

              final transaction = TransactionModel(
                id: DateTime.now().toString(),
                title: tittleController.text,
                amount: amount!,
                date: selectedDate,
                type: type!,
                categoryId: selectedCategory!.id!, walletId: selectedWallet!.id!,
              );

              final transactionBloc = context.read<TransactionBloc>();

              transactionBloc.add(AddTransaction(transaction));

              if (!context.mounted) return;

              Navigator.pop(context);
            },
            child: Text(
              'Xác nhận',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
