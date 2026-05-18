import '../../data/models/wallet_model.dart';

abstract class WalletRepository {
  Future<List<WalletModel>> getWallets();

  Future<void> addWallet(WalletModel wallet);

  Future<void> deleteWallet(int id);

  Future<void> updateWalletBalance(int id, double balance);
}