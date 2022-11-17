import 'package:check_sms/features/personal/events/bank_manage_event.dart';
import 'package:check_sms/features/personal/repositories/bank_manage_repository.dart';
import 'package:check_sms/features/personal/states/bank_manage_state.dart';
import 'package:check_sms/models/bank_account_dto.dart';
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
      emit(BankManageLoadingState());
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
      emit(BankManageLoadingState());
      if (event is BankManageEventAddDTO) {
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
      emit(BankManageLoadingState());
      if (event is BankManageEventRemoveDTO) {
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
