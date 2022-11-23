import 'package:vierqr/features_mobile/login/events/login_event.dart';
import 'package:vierqr/features_mobile/login/repositories/login_repository.dart';
import 'package:vierqr/features_mobile/login/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginEventByPhone>(_login);
    on<LoginEventGetUserInformation>(_getUserInformation);
  }
}

const LoginRepository loginRepository = LoginRepository();

void _login(LoginEvent event, Emitter emit) async {
  try {
    if (event is LoginEventByPhone) {
      emit(LoginLoadingState());
      Map<String, dynamic> result = await loginRepository.login(event.dto);
      if (result['isLogin']) {
        emit(LoginSuccessfulState(userId: result['userId']));
      } else {
        emit(LoginFailedState());
      }
    }
  } catch (e) {
    print('Error at login - LoginBloc: $e');
    emit(LoginFailedState());
  }
}

void _getUserInformation(LoginEvent event, Emitter emit) async {
  try {
    if (event is LoginEventGetUserInformation) {
      bool isSuccess = await loginRepository.getUserInformation(event.userId);
      if (isSuccess) {
        emit(LoginGetUserInformationSuccessfulState());
      } else {
        emit(LoginFailedState());
      }
    }
  } catch (e) {
    print('Error at getUserInformation - LoginBloc: $e');
    emit(LoginFailedState());
  }
}
