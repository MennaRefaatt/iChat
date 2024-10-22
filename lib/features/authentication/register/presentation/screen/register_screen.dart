import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/extensions/spacing.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/utils/navigators.dart';
import '../../../../../core/widgets/app_button.dart';
import '../manager/register_cubit.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final cubit = RegisterCubit(sl());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            verticalSpacing(150.h),
            Center(
              child: Text(
                "SignUp",
                style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary),
              ),
            ),
            RegisterForm(cubit: cubit),
            verticalSpacing(15.h),
            BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) {
                if (state is RegisterLoadingState) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ));
                } else {
                  return AppButton(
                    width: 120.w,
                    borderRadius: 30,
                    backgroundColor: AppColors.primary,
                    onPressed: () {
                      if (cubit.userDataFormValidators.formKey.currentState!
                          .validate()) {
                        cubit.register();
                      }
                    },
                    text: "Sign Up",
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                  );
                }
              },
            ),
            verticalSpacing(10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'I Already Have An Account',
                  style: TextStyle(
                      color: AppColors.greyBorder,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      pop(context);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        ),
      )),
    );
  }
}
