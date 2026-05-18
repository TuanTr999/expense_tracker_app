import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expense_tracker_app/core/constants/app_colors.dart';
import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:expense_tracker_app/core/enums/app_status.dart';
import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:expense_tracker_app/features/categories/data/models/category_model.dart';
import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_event.dart';
import 'package:expense_tracker_app/features/transactions/data/models/transaction_model.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_event.dart';
import 'package:expense_tracker_app/features/wallet/data/models/wallet_model.dart';
import 'package:expense_tracker_app/features/wallet/presentation/blocs/wallet_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/blocs/wallet_event.dart';
import 'package:expense_tracker_app/features/wallet/presentation/blocs/wallet_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/app_type.dart';
import '../../../../core/utils/current_date.dart';
import '../../../categories/presentation/blocs/category/category_bloc.dart';
import '../../../categories/presentation/blocs/category/category_state.dart';
import '../../../categories/presentation/pages/all_category.dart';
import '../blocs/transaction/transaction_state.dart';

class UpdateTransactionPage extends StatefulWidget {
  const UpdateTransactionPage({
    super.key,
    required this.currentTransaction,
  });

  final TransactionModel currentTransaction;

  @override
  State<UpdateTransactionPage> createState() => _UpdateTransactionPageState();
}

class _UpdateTransactionPageState extends State<UpdateTransactionPage> {
  final amountController = TextEditingController();
  final tittleController = TextEditingController();

  late final TransactionModel currentTransaction;
  late DateTime selectedDate;

  CategoryModel? selectedCategory;
  WalletModel? selectedWallet;

  @override
  void initState() {
    super.initState();

    currentTransaction = widget.currentTransaction;
    selectedDate = currentTransaction.date;

    amountController.text = currentTransaction.amount % 1 == 0
        ? currentTransaction.amount.toInt().toString()
        : currentTransaction.amount.toString();

    tittleController.text = currentTransaction.title;

    selectedCategory = CategoryModel(
      id: currentTransaction.categoryId,
      name: '',
      icon: '',
      type: currentTransaction.type,
    );

    selectedWallet = WalletModel(
      id: currentTransaction.walletId,
      name: currentTransaction.walletName ?? '',
      type: currentTransaction.walletType!,
      icon: currentTransaction.walletIcon,
      balance: 0,
    );

    context.read<CategoryBloc>().add(
      LoadCategoryByTypeEvent(currentTransaction.type),
    );

    context.read<WalletBloc>().add(LoadWalletsEvent());
  }

  @override
  void dispose() {
    amountController.dispose();
    tittleController.dispose();
    super.dispose();
  }

  CategoryModel? _findCategory(List<CategoryModel> categories) {
    for (final item in categories) {
      if (item.id == selectedCategory?.id) return item;
    }
    return null;
  }

  WalletModel? _findWallet(List<WalletModel> wallets) {
    for (final item in wallets) {
      if (item.id == selectedWallet?.id) return item;
    }
    return null;
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
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, size: 30),
            ),
            Container(
              width: 240,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentTransaction.type == AppType.expense
                          ? Colors.red
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
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
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
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
                      child: const AllCategory(),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _UpdateRow(
              label: 'Ngày',
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
                child: Center(
                  child: Text(
                    formatDate(FilterType.day, selectedDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),

            const Divider(color: Colors.grey, thickness: 1, height: 20),

            _UpdateRow(
              label: 'Tiền',
              child: TextField(
                controller: amountController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '0',
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            const Divider(color: Colors.grey, thickness: 1, height: 20),

            _UpdateRow(
              label: 'Ghi chú',
              child: TextField(
                controller: tittleController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Ghi chú',
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            const Divider(color: Colors.grey, thickness: 1, height: 20),

            _UpdateRow(
              label: 'Danh mục',
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state.status == AppStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final categories = state.categories;
                  final currentValue = _findCategory(categories);

                  if (categories.isEmpty) {
                    return const Center(
                      child: Text(
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
                      valueListenable: ValueNotifier(currentValue),
                      hint: const Text(
                        'Chọn danh mục',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      items: categories.map<DropdownItem<CategoryModel>>((item) {
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

            const Divider(color: Colors.grey, thickness: 1, height: 20),

            _UpdateRow(
              label: 'Nguồn tiền',
              child: BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (state.status == AppStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final wallets = state.wallets;
                  final currentValue = _findWallet(wallets);

                  if (wallets.isEmpty) {
                    return const Center(
                      child: Text(
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
                      valueListenable: ValueNotifier(currentValue),
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
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
              } else if (selectedCategory == null) {
                error = 'Chọn danh mục';
              } else if (selectedWallet == null) {
                error = 'Chọn nguồn tiền';
              }

              if (error.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error)),
                );
                return;
              }

              final transaction = TransactionModel(
                id: currentTransaction.id,
                title: tittleController.text,
                amount: amount!,
                date: selectedDate,
                type: currentTransaction.type,
                categoryId: selectedCategory!.id!,
                walletId: selectedWallet!.id!,
              );

              final transactionBloc = context.read<TransactionBloc>();

              transactionBloc.add(UpdateTransaction(transaction));

              if (!context.mounted) return;

              Navigator.pop(context);
            },
            child: const Text(
              'Cập nhật',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UpdateRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _UpdateRow({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 25),
        Expanded(
          child: Container(
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}