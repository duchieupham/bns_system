import 'package:check_sms/models/bank_account_dto.dart';
import 'package:equatable/equatable.dart';

class BankManageState extends Equatable {
  const BankManageState();
  @override
  List<Object?> get props => [];
}

class BankManageInitialState extends BankManageState {
  @override
  List<Object?> get props => [];
}

class BankManageLoadingState extends BankManageState {
  @override
  List<Object?> get props => [];
}

class BankManageListSuccessState extends BankManageState {
  final List<BankAccountDTO> list;
  const BankManageListSuccessState({required this.list});

  @override
  List<Object?> get props => [list];
}

class BankManageListFailedState extends BankManageState {}

class BankManageAddSuccessState extends BankManageState {}

class BankManageAddFailedState extends BankManageState {}

class BankManageRemoveSuccessState extends BankManageState {}

class BankManageRemoveFailedState extends BankManageState {}
