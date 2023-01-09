import 'package:equatable/equatable.dart';
import 'package:vierqr/models/user_information_dto.dart';

class UserEditEvent extends Equatable {
  const UserEditEvent();
  @override
  List<Object?> get props => [];
}

class UserEditInformationEvent extends UserEditEvent {
  final UserInformationDTO userInformationDTO;

  const UserEditInformationEvent({required this.userInformationDTO});

  @override
  List<Object?> get props => [userInformationDTO];
}

class UserEditPasswordEvent extends UserEditEvent {
  final String userId;
  final String phoneNo;
  final String oldPassword;
  final String newPassword;

  const UserEditPasswordEvent({
    required this.userId,
    required this.phoneNo,
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [userId, phoneNo, oldPassword, newPassword];
}
