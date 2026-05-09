import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc(this.repository) : super(TransactionState(transactions: [])) {
    on<LoadTransactionEvent>(_onLoadTransactions);

    on<AddTransactionEvent>(_onAddTransaction);

    on<UpdateTransactionEvent>(_onUpdateTransaction);

    on<DeleteTransactionEvent>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(
    LoadTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final data = await repository.getTransactions();

      emit(state.copyWith(transactions: data));
    } catch (e) {
      print('LOAD TRANSACTION ERROR: $e');
    }
  }

  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await repository.addTransaction(event.transaction);

      final data = await repository.getTransactions();

      emit(state.copyWith(transactions: data));
    } catch (e) {
      print('ADD TRANSACTION ERROR: $e');
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await repository.updateTransaction(event.transaction);

      final data = await repository.getTransactions();

      emit(state.copyWith(transactions: data));
    } catch (e) {
      print('UPDATE TRANSACTION ERROR: $e');
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await repository.deleteTransaction(event.id);

      final data = await repository.getTransactions();

      emit(state.copyWith(transactions: data));
    } catch (e) {
      print('DELETE TRANSACTION ERROR: $e');
    }
  }
}
