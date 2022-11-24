import 'package:vierqr/models/bank_account_dto.dart';
import 'package:equatable/equatable.dart';

class BankManageEvent extends Equatable {
  const BankManageEvent();
  @override
  List<Object> get props => [];
}

class BankManageEventGetList extends BankManageEvent {
  final String userId;
  const BankManageEventGetList({required this.userId});
  @override
  List<Object> get props => [userId];
}

class BankManageEventAddDTO extends BankManageEvent {
  final String userId;
  final BankAccountDTO dto;

  const BankManageEventAddDTO({required this.userId, required this.dto});

  @override
  List<Object> get props => [dto];
}

class BankManageEventRemoveDTO extends BankManageEvent {
  final String userId;
  final String bankCode;

  const BankManageEventRemoveDTO({
    required this.userId,
    required this.bankCode,
  });

  @override
  List<Object> get props => [userId, bankCode];
}
