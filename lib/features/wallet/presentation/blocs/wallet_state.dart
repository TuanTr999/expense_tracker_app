import '../../../../core/enums/app_status.dart';
import '../../data/models/wallet_model.dart';

class WalletState {
  final AppStatus status;
  final List<WalletModel> wallets;
  final String? error;

  WalletState({
    this.status = AppStatus.initial,
    this.wallets = const [],
    this.error,
  });

  WalletState copyWith({
    AppStatus? status,
    List<WalletModel>? wallets,
    String? error,
  }) {
    return WalletState(
      status: status ?? this.status,
      wallets: wallets ?? this.wallets,
      error: error,
    );
  }
}