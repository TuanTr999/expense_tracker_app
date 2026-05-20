import 'package:expense_tracker_app/core/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_icon.dart';
import '../../../../../core/enums/app_status.dart';
import '../../../../../core/enums/wallet_type.dart';
import '../../../data/models/wallet_model.dart';
import '../../blocs/wallet_bloc.dart';
import '../../blocs/wallet_event.dart';
import '../../blocs/wallet_state.dart';
import 'add_wallet_page.dart';


class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(LoadWalletsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: const Text(
                  "Tài sản",
                  style: const TextStyle(
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
      body: Stack(
        children: [
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if (state.status == AppStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              final wallets = state.wallets;

              return ListView(
                padding: const EdgeInsets.only(top: 4, left: 16, bottom: 150, right: 16),
                children: [
                  _WalletGroup(
                    title: 'Tiền mặt',
                    type: WalletType.cash,
                    wallets: wallets,
                  ),
                  _WalletGroup(
                    title: 'Thẻ ngân hàng',
                    type: WalletType.bank,
                    wallets: wallets,
                  ),
                  _WalletGroup(
                    title: 'Ví điện tử',
                    type: WalletType.ewallet,
                    wallets: wallets,
                  ),
                ],
              );
            },
          ),
      _AddWalletButton()
        ],
      ),
    );
  }
}

class _WalletGroup extends StatelessWidget {
  final String title;
  final WalletType type;
  final List<WalletModel> wallets;

  const _WalletGroup({
    required this.title,
    required this.type,
    required this.wallets,
  });

  @override
  Widget build(BuildContext context) {
    final items = wallets
        .where(
          (e) =>
      e.type == type &&
          e.balance != 0,
    )
        .toList();

    final total = items.fold<double>(
      0,
          (sum, item) => sum + item.balance,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              AppFormat.currency(total),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: total < 0 ? Colors.deepOrange : Colors.blue,
              ),
            ),

          ],
        ),

        const SizedBox(height: 10),

        if (items.isEmpty)
          _EmptyWalletItem(type: type)
        else
          ...items.map((wallet) {
            return _WalletItem(wallet: wallet);
          }),
      ],
    );
  }
}

class _WalletItem extends StatefulWidget {
  final WalletModel wallet;

  const _WalletItem({
    required this.wallet,
  });

  @override
  State<_WalletItem> createState() => _WalletItemState();
}

class _WalletItemState extends State<_WalletItem> {
  late final TextEditingController balanceController;
  late final FocusNode focusNode;
  late WalletBloc walletBloc;

  String _onlyNumber(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  @override
  void initState() {
    super.initState();

    balanceController = TextEditingController(
      text: AppFormat.currency(widget.wallet.balance),
    );

    focusNode = FocusNode();

    focusNode.addListener(() {
      final rawValue = _onlyNumber(balanceController.text);

      if (focusNode.hasFocus) {
        balanceController.text = rawValue;
      } else {
        _saveBalance();

        final amount = double.tryParse(rawValue) ?? 0;
        balanceController.text = AppFormat.currency(amount);
      }

      balanceController.selection = TextSelection.collapsed(
        offset: balanceController.text.length,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    walletBloc = context.read<WalletBloc>();
  }

  @override
  void didUpdateWidget(covariant _WalletItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.wallet.balance != widget.wallet.balance) {
      balanceController.text = AppFormat.currency(widget.wallet.balance);

      balanceController.selection = TextSelection.collapsed(
        offset: balanceController.text.length,
      );
    }
  }

  void _saveBalance() {
    if (widget.wallet.id == null) return;

    final rawValue = _onlyNumber(balanceController.text);
    final newBalance = double.tryParse(rawValue) ?? 0;

    walletBloc.add(
      UpdateWalletBalanceEvent(
        id: widget.wallet.id!,
        balance: newBalance,
      ),
    );
  }

  @override
  void dispose() {
    balanceController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = widget.wallet;

    return Container(
      height: 82,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          _WalletIcon(wallet: wallet),

          const SizedBox(width: 10,),
          Text(
            wallet.name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10,),

          Expanded(
            child: SizedBox(
              // width: 130,
              child: TextField(
                controller: balanceController,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletIcon extends StatelessWidget {
  final WalletModel wallet;

  const _WalletIcon({
    required this.wallet,
  });

  @override
  Widget build(BuildContext context) {
    if (wallet.icon != null && wallet.icon!.isNotEmpty) {
      return Image.asset(
        'assets/icons/wallet/${wallet.icon}',
        width: 38,
        height: 38,
        errorBuilder: (_, __, ___) {
          return _DefaultIcon(type: wallet.type);
        },
      );
    }

    return _DefaultIcon(type: wallet.type);
  }
}

class _DefaultIcon extends StatelessWidget {
  final WalletType type;

  const _DefaultIcon({
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;

    switch (type) {
      case WalletType.cash:
        icon = Icons.payments_rounded;
        break;
      case WalletType.bank:
        icon = Icons.account_balance_rounded;
        break;
      case WalletType.ewallet:
        icon = Icons.wallet_rounded;
        break;
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.grey,
        size: 24,
      ),
    );
  }
}

class _EmptyWalletItem extends StatelessWidget {
  final WalletType type;

  const _EmptyWalletItem({
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          _DefaultIcon(type: type),
          const SizedBox(width: 20),
          const Expanded(
            child: Text(
              'Chưa có tài khoản',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddWalletButton extends StatelessWidget {
  const _AddWalletButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 90,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 1,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<WalletBloc>(),
                    child: const AddWalletPage(),
                  ),
                ),
              );
            },
            child: const Text(
              'Thêm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}