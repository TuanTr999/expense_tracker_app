import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/app_status.dart';
import '../../data/repositories/wallet_repository.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository repository;

  WalletBloc(this.repository) : super(WalletState()) {
    on<LoadWalletsEvent>(_onLoadWallets);
    on<AddWalletEvent>(_onAddWallet);
    on<DeleteWalletEvent>(_onDeleteWallet);
    on<UpdateWalletBalanceEvent>(_onUpdateWalletBalance);
  }

  Future<void> _onLoadWallets(
      LoadWalletsEvent event,
      Emitter<WalletState> emit,
      ) async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      final wallets = await repository.getWallets();

      emit(state.copyWith(
        status: AppStatus.success,
        wallets: wallets,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AppStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAddWallet(
      AddWalletEvent event,
      Emitter<WalletState> emit,
      ) async {
    await repository.addWallet(event.wallet);
    add(LoadWalletsEvent());
  }

  Future<void> _onDeleteWallet(
      DeleteWalletEvent event,
      Emitter<WalletState> emit,
      ) async {
    await repository.deleteWallet(event.id);
    add(LoadWalletsEvent());
  }

  Future<void> _onUpdateWalletBalance(
      UpdateWalletBalanceEvent event,
      Emitter<WalletState> emit,
      ) async {
    try {
      await repository.updateWalletBalance(event.id, event.balance);
      add(LoadWalletsEvent());
    } catch (e) {
      emit(
        state.copyWith(
          status: AppStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
}