import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessfulState extends LoginState {
  final String userId;

  const LoginSuccessfulState({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoginFailedState extends LoginState {}

class LoginGetUserInformationSuccessfulState extends LoginState {}
