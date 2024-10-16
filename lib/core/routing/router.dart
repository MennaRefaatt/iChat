
import 'package:flutter/material.dart';
import 'package:iChat/chats_screen.dart';
import 'package:iChat/core/routing/routing_endpoints.dart';
import 'package:iChat/video_call_screen.dart';

import '../utils/safe_print.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    safePrint('generateRoute => ${routeSettings.name}');
    safePrint('generateRoute => ${routeSettings.arguments}');

    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SizedBox());

      // case RoutingEndpoints.login:
      //   return MaterialPageRoute(builder: (_) => LoginScreen());
      //
      // case RoutingEndpoints.register:
      //   return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case RoutingEndpoints.chats:
        return MaterialPageRoute(builder: (_) => ChatsScreen());

      case RoutingEndpoints.videoCall:
        return MaterialPageRoute(builder: (_) => const VideoCallScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page Not Found"),
        ),
      );
    });
  }
}
