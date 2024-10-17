import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:iChat/features/authentication/register/data/models/register_model.dart';
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
    final response = await _registerUseCase.execute(RegisterRequestEntity(
      name: userDataFormValidators.nameController.text,
      email: userDataFormValidators.emailController.text,
      password: userDataFormValidators.passwordController.text,
    ));
    if(response != null) {
      emit(RegisterSuccessState(response));
    }else {
      emit(RegisterErrorState(response.toString()));
    }

  }
}
