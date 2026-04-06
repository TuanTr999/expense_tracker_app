import 'package:expense_tracker_app/blocs/navigation/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/navigation/navigation_event.dart';
import '../../blocs/navigation/navigation_state.dart';
import '../home/home_tab.dart';
import '../wallet/wallet_screen.dart';
import '../budget/budget_screen.dart';
import '../settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // final List<Widget> pages = [
  //   HomeTab(),
  //   WalletScreen(),
  //   BudgetScreen(),
  //   SettingsScreen(),
  // ];

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
              _item(Icons.home, 0),
              _item(Icons.account_balance_wallet, 1),

              const SizedBox(width: 40),

              _item(Icons.pie_chart, 2),
              _item(Icons.person, 3),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        elevation: 3,
        backgroundColor: Colors.blue,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _item(IconData icon, int index) {
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
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: state.currentIndex == index ? Colors.blue : Colors.grey),
          );
        },
      ),
    );
  }
}
