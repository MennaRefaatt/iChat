import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iChat/core/utils/safe_print.dart';
import 'package:meta/meta.dart';
import '../../../../../core/forms/user_data_form_validators.dart';
import '../../domain/entity/register_request_entity.dart';
import '../../domain/usecases/register_usecase.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._registerUseCase) : super(RegisterInitial());
  final RegisterUseCase _registerUseCase;
  UserDataFormValidators userDataFormValidators = UserDataFormValidators();

  register() async {
    emit(RegisterLoadingState());
    try {
      final result = await _registerUseCase.execute(RegisterRequestEntity(
        name: userDataFormValidators.nameController.text,
        email: userDataFormValidators.emailController.text,
        password: userDataFormValidators.passwordController.text,
      ));
      if (result == true) {
        safePrint("response => $result");
        emit(RegisterSuccessState(result));
      } else {
        emit(RegisterErrorState(result.toString())); // Handle generic errors here
      }
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'email-already-in-use') {
          emit(RegisterErrorState("Email already in use"));
        }
        if (error.code == 'weak-password') {
          emit(RegisterErrorState("Password should be at least 6 characters"));
        } else {
          emit(RegisterErrorState("An error occurred. Please try again"));
        }
      } else {
        emit(RegisterErrorState("An unexpected error occurred"));
      }
    }
  }
}
