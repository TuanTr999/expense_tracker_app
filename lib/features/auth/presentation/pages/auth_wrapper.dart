import 'package:dio/dio.dart';
import 'package:expense_tracker_app/features/auth/data/repositories/auth_repository.dart';
import 'package:expense_tracker_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:expense_tracker_app/features/auth/presentation/pages/login_screen.dart';
import 'package:expense_tracker_app/features/navigation/presentation/pages/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

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
          return const MainScreen();
        }

        return const LoginScreen();
      },
    );
  }
}