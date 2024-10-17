
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iChat/core/routing/routing_endpoints.dart';
import 'package:iChat/core/utils/navigators.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/extensions/spacing.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/utils/safe_print.dart';
import '../../../../../core/widgets/app_button.dart';
import '../manager/login_cubit.dart';
import '../widgets/email_and_pass.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final cubit = LoginCubit(sl());

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
                  "signInToEShop",
                  style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
              ),
              EmailAndPassword(cubit: cubit),
              verticalSpacing(15.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text("forgotPassword",
                      style: TextStyle(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                          fontSize: 15.sp)),
                ),
              ),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  if (state is LoginSuccess) {
                     Router.navigate(context, RoutingEndpoints.chat as VoidCallback);
                  }
                  if (state is LoginLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primary,
                      backgroundColor: Colors.white70,
                    ));
                  } else {
                    return AppButton(
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        safePrint("clicked");
                        if (cubit.userDataFormValidators.formKey.currentState!
                            .validate()) {
                          cubit.login();
                        }
                      },
                      text: "signIn",
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
                  Text("dontHaveAnAccount",
                      style: TextStyle(
                          color: AppColors.greyBorder,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold)),
                  TextButton(
                      onPressed: () {
                        pushNamed(context, RoutingEndpoints.register);
                      },
                      child: Text(
                        "signUp",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
