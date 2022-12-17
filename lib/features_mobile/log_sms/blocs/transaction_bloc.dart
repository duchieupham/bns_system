import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/features_mobile/log_sms/events/transaction_event.dart';
import 'package:vierqr/features_mobile/log_sms/repositories/transaction_repository.dart';
import 'package:vierqr/features_mobile/log_sms/states/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(const TransactionInitialState()) {
    on<TransactionEventInsert>(_insertTransaction);
  }
}

const TransactionRepository transactionRepository = TransactionRepository();

void _insertTransaction(TransactionEvent event, Emitter emit) async {
  try {
    if (event is TransactionEventInsert) {
      if (event.transactionDTO.bankId.isNotEmpty) {
        await transactionRepository.insertTransaction(event.transactionDTO);
        emit(TransactionInsertSuccessState(
          bankId: event.transactionDTO.bankId,
          transactionId: event.transactionDTO.id,
          timeInserted: event.transactionDTO.timeInserted,
          address: event.transactionDTO.address,
          transaction: event.transactionDTO.transaction,
        ));
      }
    }
  } catch (e) {
    print('Error at _insertTransaction - TransactionBloc: $e');
    emit(const TransactionInsertFailedState());
  }
}
