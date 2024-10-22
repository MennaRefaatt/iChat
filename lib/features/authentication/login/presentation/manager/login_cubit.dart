import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    try {
      final user = await _loginUseCase.execute(LoginRequestEntity(
        email: userDataFormValidators.emailController.text,
        password: userDataFormValidators.passwordController.text,
      ));
      if (user != null) {
        emit(LoginSuccess(user));
      } else {
        emit(LoginError(user.toString()));
      }
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          emit(LoginError("No user found for that email."));
        } else if (error.code == 'wrong-password') {
          emit(LoginError("Wrong password provided for that user."));
        } else if (error.code == 'invalid-email') {
          throw Exception("The email address is not valid.");
        } else {
          emit(LoginError("An error occurred. Please try again"));
        }
      } else {
        emit(LoginError("An unexpected error occurred"));
      }
    }
  }
}
