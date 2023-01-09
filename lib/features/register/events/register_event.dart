import 'package:vierqr/models/account_register_dto.dart';
import 'package:equatable/equatable.dart';

class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterEventSubmit extends RegisterEvent {
  final AccountRegisterDTO dto;

  const RegisterEventSubmit({required this.dto});

  @override
  List<Object?> get props => [dto];
}
