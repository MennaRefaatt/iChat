import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iChat/core/utils/navigators.dart';
import '../../../../../core/extensions/spacing.dart';
import '../../../../../core/routing/routing_endpoints.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/widgets/app_text_form_field.dart';
import '../manager/login_cubit.dart';

class EmailAndPassword extends StatefulWidget {
  const EmailAndPassword({super.key, required this.cubit});
  final LoginCubit cubit;

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.loginData as String),
              backgroundColor: AppColors.green,
            ),
          );
          pushNamed(context, RoutingEndpoints.chats);
        }
        if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red[900],
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
                textInputAction: TextInputAction.next,
                withTitle: true,
                controller: widget.cubit.userDataFormValidators.emailController,
                backgroundColor: AppColors.primaryLight,
                keyboardType: TextInputType.emailAddress,
                hintText: "shop@gmail.com",
                title: "email",
                validator: (value) =>
                    widget.cubit.userDataFormValidators.validateEmail(value!)),
            verticalSpacing(15.h),
            AppTextFormField(
              withTitle: true,
              hintText: "xxxxxxxxx",
              textInputAction: TextInputAction.next,
              title: "password",
              backgroundColor: AppColors.primaryLight,
              keyboardType: TextInputType.visiblePassword,
              isObscureText:
                  widget.cubit.userDataFormValidators.isPasswordVisible,
              validator: (value) =>
                  widget.cubit.userDataFormValidators.validatePassword(value!),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    widget.cubit.userDataFormValidators.isPasswordVisible =
                        !widget.cubit.userDataFormValidators.isPasswordVisible;
                  });
                },
                icon: Icon(
                  widget.cubit.userDataFormValidators.isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppColors.greyBorder,
                ),
              ),
              controller:
                  widget.cubit.userDataFormValidators.passwordController,
            ),
          ]),
        ),
      ),
    );
  }
}
