import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/features/personal/events/user_edit_event.dart';
import 'package:vierqr/features/personal/repositories/user_edit_repository.dart';
import 'package:vierqr/features/personal/states/user_edit_state.dart';

class UserEditBloc extends Bloc<UserEditEvent, UserEditState> {
  UserEditBloc() : super(UserEditInitialState()) {
    on<UserEditInformationEvent>(_updateUserInformation);
    on<UserEditPasswordEvent>(_updatePassword);
  }

  final UserEditRepository userEditRepository = const UserEditRepository();

  void _updateUserInformation(UserEditEvent event, Emitter emit) async {
    try {
      if (event is UserEditInformationEvent) {
        emit(UserEditLoadingState());
        bool check = await userEditRepository
            .updateUserInformation(event.userInformationDTO);
        if (check) {
          emit(UserEditSuccessfulState());
        } else {
          emit(UserEditFailedState());
        }
      }
    } catch (e) {
      print('Error at _updateUserInformation - UserEditBloc: $e');
      emit(UserEditFailedState());
    }
  }

  void _updatePassword(UserEditEvent event, Emitter emit) async {
    try {
      if (event is UserEditPasswordEvent) {
        emit(UserEditLoadingState());
        Map<String, dynamic> result = await userEditRepository.updatePassword(
            event.userId, event.oldPassword, event.newPassword, event.phoneNo);
        if (result['check']) {
          emit(UserEditPasswordSuccessfulState());
        } else {
          emit(UserEditPasswordFailedState(msg: result['msg']));
        }
      }
    } catch (e) {
      print('Error at _updatePassworc - UserEditBloc: $e');
      emit(const UserEditPasswordFailedState(
          msg: 'Vui lòng kiểm tra lại kết nối mạng.'));
    }
  }
}
