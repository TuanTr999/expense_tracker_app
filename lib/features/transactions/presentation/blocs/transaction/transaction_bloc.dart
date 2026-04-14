import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc(this.repository) : super(TransactionState(transactions: [])) {
    on<LoadTransactionEvent>((event, emit) async {
      final data = await repository.getTransactions();
      emit(state.copyWith(transactions: data));
    });

    on<AddTransactionEvent>((event, emit) async {
      await repository.addTransaction(event.transaction);

      // print("✅ INSERT OK: ${event.transaction.title}");

      final data = await repository.getTransactions();

      // print("📦 TOTAL AFTER INSERT: ${data.length}");
      // print("📦 LAST ITEM: ${data.last.title}");

      emit(state.copyWith(transactions: data));
    });

    on<UpdateTransactionEvent>((event, emit) async {
      await repository.updateTransaction(event.transaction);

      final data = await repository.getTransactions();
      emit(state.copyWith(transactions: data));
    });

   on<DeleteTransactionEvent>((event, emit) async {
      await repository.deleteTransaction(event.id);

      final data = await repository.getTransactions();
      emit(state.copyWith(transactions: data));
    });

  }
}
