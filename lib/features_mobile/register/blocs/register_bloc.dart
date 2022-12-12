import 'package:vierqr/features_mobile/register/events/register_event.dart';
import 'package:vierqr/features_mobile/register/repositories/register_repository.dart';
import 'package:vierqr/features_mobile/register/states/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/models/checking_dto.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitialState()) {
    on<RegisterEventSubmit>(_register);
  }
}

const RegisterRepository registerRepository = RegisterRepository();

void _register(RegisterEvent event, Emitter emit) async {
  try {
    if (event is RegisterEventSubmit) {
      emit(RegisterLoadingState());
      CheckingDTO checkingDTO = await registerRepository.register(event.dto);
      if (checkingDTO.check) {
        emit(RegisterSuccessState());
      } else {
        emit(RegisterFailedState(msg: checkingDTO.message));
      }
    }
  } catch (e) {
    print('Error at register - RegisterBloc: $e');
    emit(const RegisterFailedState(
        msg: 'Không thể đăng ký. Vui lòng kiểm tra lại kết nối.'));
  }
}
