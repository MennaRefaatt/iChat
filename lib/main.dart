import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  await SharedPref.init();
  int? userId = SharedPref.getInt(key: MySharedKeys.userId);
  safePrint("userId $userId");

  String? deviceToken = await FirebaseMessaging.instance.getToken();
  safePrint("deviceToken $deviceToken");

  String? token = await SecureStorageService.readData(SecureKeys.token);
  safePrint("token $token");

  await init();
  runApp(
    const MyApp(),
  );
}

final appNavKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            deviceData =
                _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
            break;
          case TargetPlatform.iOS:
            deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
            break;
          case TargetPlatform.macOS:
            deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
            break;
          case TargetPlatform.windows:
            deviceData =
                _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
            break;
          case TargetPlatform.linux:
            deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
            break;
          default:
            throw UnsupportedError("Unsupported platform");
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.incremental': build.version.incremental,
      'brand': build.brand,
      'model': build.model,
      'isPhysicalDevice': build.isPhysicalDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo info) {
    return <String, dynamic>{
      'browserName': describeEnum(info.browserName),
      'appCodeName': info.appCodeName,
      'appName': info.appName,
      'appVersion': info.appVersion,
      'deviceMemory': info.deviceMemory,
      'language': info.language,
      'platform': info.platform,
      'userAgent': info.userAgent,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo info) {
    return <String, dynamic>{
      'computerName': info.computerName,
      'numberOfCores': info.numberOfCores,
      'systemMemoryInMegabytes': info.systemMemoryInMegabytes,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo info) {
    return <String, dynamic>{
      'model': info.model,
      'osRelease': info.osRelease,
      'systemGUID': info.systemGUID,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo info) {
    return <String, dynamic>{
      'name': info.name,
      'version': info.version,
      'id': info.id,
      'idLike': info.idLike,
      'versionCodename': info.versionCodename,
      'versionId': info.versionId,
      'prettyName': info.prettyName,
    };
  }

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
              initialRoute: '/',
              // home: Scaffold(
              //     appBar: AppBar(
              //       title: Text('Device Info Example'),
              //     ),
              //     body: Center(
              //         child: ListView(
              //       children: _deviceData.keys.map((String property) {
              //         return Row(
              //           children: [
              //             Expanded(child: Text(property)),
              //             Expanded(
              //               child: Text(
              //                 '${_deviceData[property]}',
              //                 overflow: TextOverflow.ellipsis,
              //               ),
              //             ),
              //           ],
              //         );
              //       }).toList(),
              //     ))) // Set the initial route
              );
        },
      ),
    );
  }
}
