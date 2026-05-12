import 'package:expense_tracker_app/features/calendar/presentation/pages/calender_screen.dart';
import 'package:expense_tracker_app/features/navigation/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../home/presentation/pages/home/home_tab.dart';
import '../../blocs/navigation/navigation_event.dart';
import '../../blocs/navigation/navigation_state.dart';
import 'package:expense_tracker_app/features/wallet/presentation/pages/wallet/wallet_screen.dart';
import 'package:expense_tracker_app/features/budget/presentation/pages/budget/budget_screen.dart';
import 'package:expense_tracker_app/features/settings/presentation/pages/settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomeTab(), CalenderScreen() ,WalletScreen(), BudgetScreen(), SettingsScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return IndexedStack(index: state.currentIndex, children: _pages);
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 66,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _item('assets/icons/navigation/home.png', 0, 'Trang chủ'),
                _item('assets/icons/navigation/calendar.png', 1, 'Lịch'),
                _item('assets/icons/navigation/wallet.png', 2, 'Tài sản'),
                _item('assets/icons/navigation/budget.png', 3, 'Ngân sách'),
                _item('assets/icons/navigation/settings.png', 4, 'Cài đặt'),
              ],
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _item(String iconPath, int index, String name) {
    return InkWell(
      onTap: () {
        context.read<NavigationBloc>().add(ChangePageEvent(index));
      },
      child:  BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return SizedBox(
            height: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  state.currentIndex == index
                      ? Image.asset(iconPath, width: 24, height: 24)
                      : ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey,
                            BlendMode.modulate,
                          ),
                          child: Image.asset(iconPath, width: 24, height: 24),
                        ),
                  Text(name, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: state.currentIndex == index ? Colors.black : Colors.grey),),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
