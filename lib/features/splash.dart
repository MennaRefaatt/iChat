import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iChat/core/routing/routing_endpoints.dart';
import 'package:iChat/core/styles/app_colors.dart';
import 'package:iChat/core/utils/navigators.dart';
import 'package:iChat/core/widgets/app_asset.dart';
import '../core/secure_storage/secure_keys.dart';
import '../core/secure_storage/secure_storage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () async {
      String? token = await SecureStorageService.readData(SecureKeys.token);
      if (token != null && token.isNotEmpty) {
        pushNamedAndRemoveUntil(context, RoutingEndpoints.chats);
      } else {
        pushNamedAndRemoveUntil(context, RoutingEndpoints.login);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.black,
        body: Center(
          child: AppAssetImage(
            image: 'ichat.png',
            width: 200.w,
            height: 200.h,
          ),
        ));
  }
}
