import 'package:expense_tracker_app/features/auth/data/datasources/auth_service.dart';
import 'package:expense_tracker_app/features/auth/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService service;

  AuthRepositoryImpl(this.service);

  @override
  Future<UserCredential?> login(String email, String password) async {
    try {
      final res = service.login(email: email, password: password);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return null;
    }
  }

  @override
  Future<void> logout() {
    return service.logout();
  }

  @override
  Future<UserCredential?> register(String email, String password) async {
    try {
      final res = service.register(email: email, password: password);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return null;
    }
  }

  @override
  Future<void> forgotPassword(String email) {
    return service.forgotPassword(email);
  }

  @override
  Future<void> signInWithGoogle() {
    return service.signInWithGoogle();
  }
}
