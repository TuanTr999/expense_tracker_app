import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/wallet_type.dart';
import '../../../data/models/wallet_model.dart';
import '../../blocs/wallet_bloc.dart';
import '../../blocs/wallet_event.dart';

class AddWalletPage extends StatefulWidget {
  const AddWalletPage({super.key});

  @override
  State<AddWalletPage> createState() => _AddWalletPageState();
}

class _AddWalletPageState extends State<AddWalletPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final balanceController = TextEditingController();
  final creditLimitController = TextEditingController();



  WalletType selectedType = WalletType.cash;
  String selectedIcon = 'cash.png';

  final Map<WalletType, List<String>> icons = {
    WalletType.cash: ['cash.png'],
    WalletType.bank: ['bidv.png', 'mb.png', 'techcombank.png', 'vietcombank.png', 'vietinbank.png'],
    WalletType.ewallet: ['momo.png', 'zalopay.png', 'vnpay.png'],
  };

  @override
  void dispose() {
    nameController.dispose();
    balanceController.dispose();
    creditLimitController.dispose();
    super.dispose();
  }

  void _changeType(WalletType type) {
    setState(() {
      selectedType = type;
      selectedIcon = icons[type]!.first;

    });
  }

  double _parseMoney(String value) {
    final raw = value.trim().replaceAll(',', '').replaceAll('.', '');
    return double.tryParse(raw) ?? 0;
  }

  void _saveWallet() {
    if (!_formKey.currentState!.validate()) return;

    final wallet = WalletModel(
      name: nameController.text.trim(),
      type: selectedType,
      icon: selectedIcon,
      balance: _parseMoney(balanceController.text),
    );

    context.read<WalletBloc>().add(AddWalletEvent(wallet));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final typeIcons = icons[selectedType] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppCircleButton(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
            Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Thêm thẻ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 60),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _TypeSelector(
                selectedType: selectedType,
                onChanged: _changeType,
              ),

              const SizedBox(height: 24),

              _InputBox(
                label: 'Tên tài khoản',
                hint: 'Nhập tên tài khoản',
                controller: nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên tài khoản';
                  }

                  if (value.trim().length < 2) {
                    return 'Tên tài khoản quá ngắn';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              _InputBox(
                label: 'Số dư ban đầu',
                hint: '0',
                controller: balanceController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số dư ban đầu';
                  }

                  final money = _parseMoney(value);

                  if (money < 0) {
                    return 'Số dư không được nhỏ hơn 0';
                  }

                  return null;
                },
              ),


              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Biểu tượng',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: typeIcons.map((icon) {
                  final isSelected = selectedIcon == icon;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = icon;
                      });
                    },
                    child: Container(
                      width: 62,
                      height: 62,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/icons/wallet/$icon',
                        errorBuilder: (_, __, ___) {
                          return Icon(
                            Icons.account_balance_wallet_rounded,
                            color: isSelected ? Colors.blue : Colors.grey,
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: _saveWallet,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text(
              'Xác nhận',
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

class _TypeSelector extends StatelessWidget {
  final WalletType selectedType;
  final ValueChanged<WalletType> onChanged;

  const _TypeSelector({
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final types = WalletType.values;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: types.map((type) {
            return Expanded(
              child: _WalletTypeItem(
                title: type.title,
                type: type,
                selectedType: selectedType,
                onTap: () => onChanged(type),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _WalletTypeItem extends StatelessWidget {
  final String title;
  final WalletType type;
  final WalletType selectedType;
  final VoidCallback onTap;

  const _WalletTypeItem({
    required this.title,
    required this.type,
    required this.selectedType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = type == selectedType;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Center(
        child: Text(
          title,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _InputBox({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.2,
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}