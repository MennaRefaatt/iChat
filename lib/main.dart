import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iChat/core/shared_preferences/my_shared.dart';
import 'core/di/di.dart';
import 'core/routing/router.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPref.init();
  await init();
  runApp(
    MyApp(),
  );
}
final appNavKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key, });

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
