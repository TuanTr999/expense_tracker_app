import 'package:expense_tracker_app/core/enums/app_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/auth_error_mapper.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthState(status: AppStatus.initial)) {
    on<LoginEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: AppStatus.loading, error: null));

        await repository.login(event.email, event.password);

        emit(state.copyWith(status: AppStatus.success));
      } on FirebaseAuthException catch (e) {
        emit(
          state.copyWith(
            status: AppStatus.error,
            error: AuthErrorMapper.map(e.code),
          ),
        );
      } catch (e) {
        emit(state.copyWith(status: AppStatus.error, error: e.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: AppStatus.loading, error: null));

        await repository.register(event.email, event.password);

        emit(state.copyWith(status: AppStatus.success));
      } on FirebaseAuthException catch (e) {
        emit(
          state.copyWith(
            status: AppStatus.error,
            error: AuthErrorMapper.map(e.code),
          ),
        );
      } catch (e) {
        emit(state.copyWith(status: AppStatus.error, error: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: AppStatus.loading, error: null));

        await repository.logout();

        emit(state.copyWith(status: AppStatus.success));
      } on FirebaseAuthException catch (e) {
        emit(
          state.copyWith(
            status: AppStatus.error,
            error: AuthErrorMapper.map(e.code),
          ),
        );
      } catch (e) {
        emit(state.copyWith(status: AppStatus.error, error: e.toString()));
      }
    });

    on<ForgotPasswordEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: AppStatus.loading, error: null));

        await repository.forgotPassword(event.email);

        emit(state.copyWith(status: AppStatus.success));
      } on FirebaseAuthException catch (e) {
        emit(
          state.copyWith(
            status: AppStatus.error,
            error: AuthErrorMapper.map(e.code),
          ),
        );
      } catch (e) {
        emit(state.copyWith(status: AppStatus.error, error: e.toString()));
      }
    });

    on<ResetAuthStateEvent>((event, emit) {
      emit(AuthState(status: AppStatus.initial, error: ''));
    });

    on<GoogleLoginEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: AppStatus.loading, error: null));

        await repository.signInWithGoogle();

        emit(state.copyWith(status: AppStatus.success));
      } on FirebaseAuthException catch (e) {
        emit(
          state.copyWith(
            status: AppStatus.error,
            error: AuthErrorMapper.map(e.code),
          ),
        );
      } catch (e) {
        emit(state.copyWith(status: AppStatus.error, error: e.toString()));
      }
    });
  }
}
