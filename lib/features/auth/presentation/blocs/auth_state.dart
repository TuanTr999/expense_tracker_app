import '../../../../core/enums/app_status.dart';

class AuthState {
  final AppStatus status;
  final String? error;

  AuthState({
    required this.status,
    this.error,
  });

  AuthState copyWith({
    AppStatus? status,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error,
    );
  }
}