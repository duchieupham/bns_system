import 'package:vierqr/features_mobile/register/events/register_event.dart';
import 'package:vierqr/features_mobile/register/repositories/register_repository.dart';
import 'package:vierqr/features_mobile/register/states/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      bool check = await registerRepository.register(event.dto);
      if (check) {
        emit(RegisterSuccessState());
      } else {
        emit(RegisterFailedState());
      }
    }
  } catch (e) {
    print('Error at register - RegisterBloc: $e');
    emit(RegisterFailedState());
  }
}