import 'package:check_sms/models/account_login_dto.dart';
import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEventByPhone extends LoginEvent {
  final AccountLoginDTO dto;
  const LoginEventByPhone({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class LoginEventGetUserInformation extends LoginEvent {
  final String userId;

  const LoginEventGetUserInformation({required this.userId});

  @override
  List<Object?> get props => [userId];
}
