import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/extensions/spacing.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/utils/navigators.dart';
import '../../../../../core/widgets/app_text_form_field.dart';
import '../manager/register_cubit.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.cubit,
  });

  final RegisterCubit cubit;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoadingState) {
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        } else if (state is RegisterSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
              backgroundColor: AppColors.green,
              content: Text("Register Success"),
            ),
          );
          pop(context);
        }
        if (state is RegisterErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.red,
              content: Text(state.error),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.all(15.sp),
        child: Form(
          key: widget.cubit.userDataFormValidators.formKey,
          child: Column(children: [
            AppTextFormField(
              withTitle: true,
              textInputAction: TextInputAction.next,
              controller: widget.cubit.userDataFormValidators.nameController,
              keyboardType: TextInputType.name,
              hintText: "shop",
              title: 'name',
              validator: (value) =>
                  widget.cubit.userDataFormValidators.validateName(value),
            ),
            verticalSpacing(15.h),
            AppTextFormField(
              textInputAction: TextInputAction.next,
              withTitle: true,
              controller: widget.cubit.userDataFormValidators.emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: "shop@gmail.com",
              title: 'email',
              validator: (value) =>
                  widget.cubit.userDataFormValidators.validateEmail(value),
            ),
            verticalSpacing(15.h),
            AppTextFormField(
              withTitle: true,
              hintText: "xxxxxxxxx",
              isObscureText:
                  widget.cubit.userDataFormValidators.isPasswordVisible,
              textInputAction: TextInputAction.next,
              title:'password',
              keyboardType: TextInputType.visiblePassword,
              validator: (value) =>
                  widget.cubit.userDataFormValidators.validatePassword(value),
              suffixIcon: IconButton(
                onPressed: () {
                  widget.cubit.userDataFormValidators.isPasswordVisible =
                      !widget.cubit.userDataFormValidators.isPasswordVisible;
                  setState(() {});
                },
                icon: Icon(
                    widget.cubit.userDataFormValidators.isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.greyBorder),
              ),
              controller:
                  widget.cubit.userDataFormValidators.passwordController,
            ),
            verticalSpacing(15.h),
            AppTextFormField(
              isObscureText:
                  widget.cubit.userDataFormValidators.isConfirmPasswordVisible,
              textInputAction: TextInputAction.done,
              withTitle: true,
              keyboardType: TextInputType.visiblePassword,
              hintText: "xxxxxxxxx",
              title: 'confirmPassword',
              controller:
                  widget.cubit.userDataFormValidators.confirmPasswordController,
              suffixIcon: IconButton(
                onPressed: () {
                  widget.cubit.userDataFormValidators.isConfirmPasswordVisible =
                      !widget.cubit.userDataFormValidators
                          .isConfirmPasswordVisible;
                  setState(() {});
                },
                icon: Icon(
                    widget.cubit.userDataFormValidators.isConfirmPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.greyBorder),
              ),
              validator: (value) => widget.cubit.userDataFormValidators
                  .validateConfirmPassword(value),
            ),
          ]),
        ),
      ),
    );
  }
}
