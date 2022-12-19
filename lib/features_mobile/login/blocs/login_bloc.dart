import 'package:vierqr/features_mobile/login/events/login_event.dart';
import 'package:vierqr/features_mobile/login/repositories/login_repository.dart';
import 'package:vierqr/features_mobile/login/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/models/code_login_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginEventByPhone>(_login);
    on<LoginEventGetUserInformation>(_getUserInformation);
    on<LoginEventListen>(_listenCodeLogin);
    on<LoginEventReceived>(_receivedCodeLogin);
    on<LoginEventUpdateCode>(_updateCodeLogin);
    on<LoginEventInsertCode>(_insertCodeLogin);
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
        LoginRepository.codeLoginController.sink
            .add(const CodeLoginDTO(code: '', isScanned: false, userId: ''));

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

void _listenCodeLogin(LoginEvent event, Emitter emit) {
  try {
    if (event is LoginEventListen) {
      loginRepository.listenLoginCode(event.code);
      LoginRepository.codeLoginController.listen((codeLoginDTO) {
        if (codeLoginDTO.userId.isNotEmpty) {
          event.loginBloc.add(LoginEventReceived(dto: codeLoginDTO));
        }
      });
    }
  } catch (e) {
    print('Error at _listenCodeLogin - LoginBloc: $e');
    emit(LoginFailedState());
  }
}

void _receivedCodeLogin(LoginEvent event, Emitter emit) async {
  try {
    if (event is LoginEventReceived) {
      if (event.dto.userId.isNotEmpty) {
        await UserInformationHelper.instance.setUserId(event.dto.userId);
        await loginRepository.deleteCodeLogin(event.dto.code);
        emit(LoginSuccessfulState(userId: event.dto.userId));
      }
    }
  } catch (e) {
    print('Error at _receivedCodeLogin - LoginBloc: $e');
    emit(LoginFailedState());
  }
}

void _updateCodeLogin(LoginEvent event, Emitter emit) async {
  try {
    if (event is LoginEventUpdateCode) {
      CodeLoginDTO dto =
          CodeLoginDTO(code: event.code, isScanned: true, userId: event.userId);
      await loginRepository.updateCodeLogin(dto);
    }
  } catch (e) {
    print('Error at _updateCodeLogin - LoginBloc: $e');
    emit(LoginFailedState());
  }
}

void _insertCodeLogin(LoginEvent event, Emitter emit) async {
  try {
    if (event is LoginEventInsertCode) {
      CodeLoginDTO dto =
          CodeLoginDTO(code: event.code, isScanned: false, userId: '');
      await loginRepository.insertCodeLogin(dto).then(
            (value) => event.loginBloc.add(
              LoginEventListen(code: event.code, loginBloc: event.loginBloc),
            ),
          );
    }
  } catch (e) {
    print('Error at _insertCodeLogin - LoginBloc: $e');
    emit(LoginFailedState());
  }
}
