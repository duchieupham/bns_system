import 'package:vierqr/features_mobile/personal/events/bank_manage_event.dart';
import 'package:vierqr/features_mobile/personal/repositories/bank_manage_repository.dart';
import 'package:vierqr/features_mobile/personal/states/bank_manage_state.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/services/shared_references/bank_information_helper.dart';

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
        List<String> bankIds =
            await bankManageRepository.getBankIdsByUserId(event.userId);
        await BankInformationHelper.instance.setBankIds(bankIds);
        List<BankAccountDTO> list =
            await bankManageRepository.getListBankAccount(event.userId);
        List<BankAccountDTO> listOther =
            await bankManageRepository.getListOtherBankAccount(event.userId);
        emit(
          BankManageListSuccessState(
            list: list,
            listOther: listOther,
          ),
        );
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
        bool result = await bankManageRepository.addBankAccount(
          event.userId,
          event.dto,
          event.phoneNo,
        );
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
            event.userId, event.bankCode, event.bankId);
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
