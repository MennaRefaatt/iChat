import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iChat/core/secure_storage/secure_storage.dart';
import 'package:iChat/core/utils/safe_print.dart';
import 'core/di/di.dart';
import 'core/routing/router.dart';
import 'core/secure_storage/secure_keys.dart';
import 'core/shared_preferences/my_shared.dart';
import 'core/shared_preferences/my_shared_keys.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? userId = SharedPref.getString(key: MySharedKeys.userId);
  safePrint("userId $userId");

  String? deviceToken = await FirebaseMessaging.instance.getToken();
  safePrint(deviceToken);

  String? token = await SecureStorageService.readData(SecureKeys.token);
  safePrint("token $token");

  SharedPref.init();
  await init();
  runApp(
    const MyApp(),
  );
}

final appNavKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      builder: (context) => ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            navigatorKey: appNavKey,
            onGenerateRoute: RouteServices.generateRoute,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            initialRoute: '/', // Set the initial route
          );
        },
      ),
    );
  }
}
