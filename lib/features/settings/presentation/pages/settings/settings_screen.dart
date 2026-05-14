import 'package:expense_tracker_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:expense_tracker_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:expense_tracker_app/features/navigation/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:expense_tracker_app/features/navigation/presentation/blocs/navigation/navigation_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _settingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color iconColor = Colors.blue,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.12),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: Colors.black54))
          : null,
      trailing: const Icon(Icons.chevron_right),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFF1877F2),
                    child: Icon(Icons.person, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tuấn Trịnh',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Xem trang cá nhân',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  _settingItem(
                    icon: Icons.person_outline,
                    title: 'Thông tin cá nhân',
                    subtitle: 'Quản lý tên, email và tài khoản',
                  ),
                  const Divider(height: 1),
                  _settingItem(
                    icon: Icons.lock_outline,
                    title: 'Đăng nhập & bảo mật',
                    subtitle: 'Mật khẩu và xác thực tài khoản',
                    iconColor: Colors.green,
                  ),
                  const Divider(height: 1),
                  _settingItem(
                    icon: Icons.notifications_none,
                    title: 'Thông báo',
                    subtitle: 'Quản lý nhắc nhở và cảnh báo',
                    iconColor: Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  _settingItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Quản lý ví',
                    subtitle: 'Tài khoản, ngân sách và số dư',
                    iconColor: Colors.purple,
                  ),
                  const Divider(height: 1),
                  _settingItem(
                    icon: Icons.category_outlined,
                    title: 'Danh mục thu chi',
                    subtitle: 'Tùy chỉnh danh mục giao dịch',
                    iconColor: Colors.teal,
                  ),
                  const Divider(height: 1),
                  _settingItem(
                    icon: Icons.smart_toy_outlined,
                    title: 'Trợ lý AI',
                    subtitle: 'Cài đặt chatbot tài chính',
                    iconColor: Colors.blue,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  _settingItem(
                    icon: Icons.help_outline,
                    title: 'Trợ giúp & hỗ trợ',
                    iconColor: Colors.indigo,
                  ),
                  const Divider(height: 1),
                  _settingItem(
                    icon: Icons.info_outline,
                    title: 'Giới thiệu ứng dụng',
                    iconColor: Colors.grey,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  context.read<NavigationBloc>().add(ChangePageEvent(0));
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Đăng xuất',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
