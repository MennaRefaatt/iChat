import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:iChat/features/authentication/login/data/models/login_data.dart';
import 'package:meta/meta.dart';
import '../../../../../core/forms/user_data_form_validators.dart';
import '../../domain/entities/login_request_entity.dart';
import '../../domain/usecases/login_usecase.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginUseCase) : super(LoginInitial());
  final LoginUseCase _loginUseCase;
  UserDataFormValidators userDataFormValidators = UserDataFormValidators();
  login() async {
    emit(LoginLoading());
    final user = await _loginUseCase.execute(LoginRequestEntity(
      email: userDataFormValidators.emailController.text,
      password: userDataFormValidators.passwordController.text,
    ));
    if (user != null) {
      emit(LoginSuccess(user));
    } else {
      emit(LoginError(user.toString()));
    }
  }
}
