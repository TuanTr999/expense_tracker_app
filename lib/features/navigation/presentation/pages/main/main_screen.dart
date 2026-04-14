import 'package:expense_tracker_app/features/navigation/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../transactions/presentation/blocs/filter/filter_bloc.dart';
import '../../../../transactions/presentation/blocs/transaction/transaction_bloc.dart';
import '../../../../transactions/presentation/pages/add_transaction_page.dart';
import '../../blocs/navigation/navigation_event.dart';
import '../../blocs/navigation/navigation_state.dart';
import 'package:expense_tracker_app/features/home/presentation/pages/home/home_tab.dart';
import 'package:expense_tracker_app/features/wallet/presentation/pages/wallet/wallet_screen.dart';
import 'package:expense_tracker_app/features/budget/presentation/pages/budget/budget_screen.dart';
import 'package:expense_tracker_app/features/settings/presentation/pages/settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          final pages = [
            HomeTab(),
            WalletScreen(),
            BudgetScreen(),
            SettingsScreen(),
          ];

          return IndexedStack(index: state.currentIndex, children: pages);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFF5F5F5),
        padding: EdgeInsets.only(bottom: 0, left: 20, right: 20),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item('assets/icons/navigation/home.png', 0),
              _item('assets/icons/navigation/wallet.png', 1),

              const SizedBox(width: 40),

              _item('assets/icons/navigation/budget.png', 2),
              _item('assets/icons/navigation/settings.png', 3),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        elevation: 3,
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: context.read<TransactionBloc>()),
                  BlocProvider.value(value: context.read<FilterBloc>()),
                ],
                child: AddTransactionPage(),
              ),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _item(String iconPath, int index) {
    return IconButton(
      onPressed: () {
        context.read<NavigationBloc>().add(ChangePageEvent(index));
      },
      icon: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: state.currentIndex == index
                  ? Color(0xFFF5F5F5)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: state.currentIndex == index
                  ? Image.asset(iconPath, width: 24, height: 24)
                  : ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.grey,
                        BlendMode.modulate,
                      ),
                      child: Image.asset(iconPath, width: 24, height: 24),
                    ),
            ),
          );
        },
      ),
    );
  }
}
