import 'package:vierqr/features_mobile/personal/events/bank_manage_event.dart';
import 'package:vierqr/features_mobile/personal/repositories/bank_manage_repository.dart';
import 'package:vierqr/features_mobile/personal/states/bank_manage_state.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BankManageBloc extends Bloc<BankManageEvent, BankManageState> {
  BankManageBloc() : super(BankManageInitialState()) {
    on<BankManageEventGetList>(_getListBankAccount);
    on<BankManageEventAddDTO>(_addBankAccount);
    on<BankManageEventRemoveDTO>(_removeBankAccount);
  }

  final BankManageRepository bankManageRepository =
      const BankManageRepository();

  void _getListBankAccount(BankManageEvent event, Emitter emit) async {
    try {
      if (event is BankManageEventGetList) {
        List<BankAccountDTO> list =
            await bankManageRepository.getListBankAccount(event.userId);
        emit(BankManageListSuccessState(list: list));
      }
    } catch (e) {
      print('Error at getListBankAccount - BankManageBloc: $e');
      emit(BankManageListFailedState());
    }
  }

  void _addBankAccount(BankManageEvent event, Emitter emit) async {
    try {
      if (event is BankManageEventAddDTO) {
        emit(BankManageLoadingState());
        bool result =
            await bankManageRepository.addBankAccount(event.userId, event.dto);
        if (result) {
          emit(BankManageAddSuccessState());
        }
      }
    } catch (e) {
      print('Error at getListBankAccount - BankManageBloc: $e');
      emit(BankManageAddFailedState());
    }
  }

  void _removeBankAccount(BankManageEvent event, Emitter emit) async {
    try {
      if (event is BankManageEventRemoveDTO) {
        emit(BankManageLoadingState());
        bool result = await bankManageRepository.removeBankAccount(
            event.userId, event.bankCode);
        if (result) {
          emit(BankManageRemoveSuccessState());
        }
      }
    } catch (e) {
      print('Error at getListBankAccount - BankManageBloc: $e');
      emit(BankManageRemoveFailedState());
    }
  }
}
