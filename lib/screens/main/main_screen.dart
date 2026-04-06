import 'package:flutter/material.dart';
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
  int _currentIndex = 0;

  final List<Widget> pages = [
    HomeTab(),
    WalletScreen(),
    BudgetScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),

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
    final isSelected = _currentIndex == index;

    return IconButton(
      onPressed: () {
        setState(() => _currentIndex = index);
      },
      icon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      )
    );
  }
}
