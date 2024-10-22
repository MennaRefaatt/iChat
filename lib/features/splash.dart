import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/routing/routing_endpoints.dart';
import '../core/secure_storage/secure_keys.dart';
import '../core/secure_storage/secure_storage.dart';
import '../core/styles/app_colors.dart';
import '../core/utils/navigators.dart';
import '../core/widgets/app_asset.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () async {
      pushNamedAndRemoveUntil(context, RoutingEndpoints.chats);
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
            image: 'ichat_icon.png',
            width: 200.w,
            height: 200.h,
          ),
        ));
  }
}
