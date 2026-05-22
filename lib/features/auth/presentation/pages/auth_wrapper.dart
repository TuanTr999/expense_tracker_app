import 'package:expense_tracker_app/features/navigation/presentation/pages/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/dio_client.dart';
import 'login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _synced = false;
  bool _syncing = false;

  Future<void> _syncUser() async {
    if (_syncing || _synced) return;

    _syncing = true;

    try {
      final dio = DioClient().dio;

      await dio.post('/users/sync');

      _synced = true;
    } catch (e) {
      debugPrint('Sync user failed: $e');
    } finally {
      _syncing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return FutureBuilder(
            future: _syncUser(),
            builder: (context, syncSnapshot) {
              if (syncSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              return const MainScreen();
            },
          );
        }

        _synced = false;
        return const LoginScreen();
      },
    );
  }
}