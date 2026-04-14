import '../../../data/models/transaction_model.dart';

class TransactionState {
  final List<TransactionModel> transactions;

  TransactionState({
    required this.transactions,
  });

  TransactionState copyWith({
    List<TransactionModel>? transactions,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
    );
  }
}