
import 'package:expense_tracker_app/features/wallet/data/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_datasource.dart';
import '../models/wallet_model.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<WalletModel>> getWallets() {
    return remoteDataSource.getWallets();
  }

  @override
  Future<void> addWallet(WalletModel wallet) {
    return remoteDataSource.addWallet(wallet);
  }

  @override
  Future<void> deleteWallet(int id) {
    return remoteDataSource.deleteWallet(id);
  }

  @override
  Future<void> updateWalletBalance(int id, double balance) {
    return remoteDataSource.updateWalletBalance(id, balance);
  }
}