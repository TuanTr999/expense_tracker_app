import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc(this.repository) : super(TransactionState(transactions: [])) {
    // 🔹 Load data ban đầu (optional)
    on<LoadTransactionEvent>((event, emit) async {
      final data = await repository.getTransactions();
      emit(state.copyWith(transactions: data));
    });

    // 🔹 Add
    on<AddTransactionEvent>((event, emit) async {
      await repository.addTransaction(event.transaction);

      final data = await repository.getTransactions();
      emit(state.copyWith(transactions: data));
    });

    // 🔹 Update
    on<UpdateTransactionEvent>((event, emit) async {
      await repository.updateTransaction(event.transaction);

      final data = await repository.getTransactions();
      emit(state.copyWith(transactions: data));
    });

    // 🔹 Delete
    on<DeleteTransactionEvent>((event, emit) async {
      await repository.deleteTransaction(event.id);

      final data = await repository.getTransactions();
      emit(state.copyWith(transactions: data));
    });

  }
}
