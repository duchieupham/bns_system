import 'package:equatable/equatable.dart';

class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitialState extends TransactionState {
  const TransactionInitialState();

  @override
  List<Object?> get props => [];
}

//For event insert
class TransactionInsertSuccessState extends TransactionState {
  final String bankId;
  final String transactionId;
  final dynamic timeInserted;
  final String address;
  final String transaction;

  const TransactionInsertSuccessState(
      {required this.bankId,
      required this.transactionId,
      required this.timeInserted,
      required this.address,
      required this.transaction});

  @override
  List<Object?> get props => [
        bankId,
        transactionId,
        timeInserted,
        address,
        transaction,
      ];
}

class TransactionInsertFailedState extends TransactionState {
  const TransactionInsertFailedState();

  @override
  List<Object?> get props => [];
}
