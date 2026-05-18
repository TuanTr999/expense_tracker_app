import '../../data/models/wallet_model.dart';

abstract class WalletEvent {}

class LoadWalletsEvent extends WalletEvent {}

class AddWalletEvent extends WalletEvent {
  final WalletModel wallet;

  AddWalletEvent(this.wallet);
}

class DeleteWalletEvent extends WalletEvent {
  final int id;

  DeleteWalletEvent(this.id);
}

class UpdateWalletBalanceEvent extends WalletEvent {
  final int id;
  final double balance;

  UpdateWalletBalanceEvent({
    required this.id,
    required this.balance,
  });
}