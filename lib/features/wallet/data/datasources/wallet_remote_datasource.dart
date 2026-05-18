import 'package:dio/dio.dart';

import '../models/wallet_model.dart';

class WalletRemoteDataSource {
  final Dio dio;

  WalletRemoteDataSource(this.dio);

  Future<List<WalletModel>> getWallets() async {
    final response = await dio.get('/wallets');

    return (response.data as List)
        .map((e) => WalletModel.fromJson(e))
        .toList();
  }

  Future<void> addWallet(WalletModel wallet) async {
    await dio.post('/wallets', data: wallet.toJson());
  }

  Future<void> deleteWallet(int id) async {
    await dio.delete('/wallets/$id');
  }

  Future<void> updateWalletBalance(int id, double balance) async {
    await dio.put(
      '/wallets/$id/balance',
      data: {
        'balance': balance,
      },
    );
  }
}