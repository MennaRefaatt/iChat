import 'package:flutter/material.dart';
import 'package:iChat/core/routing/routing_endpoints.dart';
import 'package:iChat/features/audio/audio_call_screen.dart';
import 'package:iChat/features/splash.dart';
import 'package:iChat/features/video/video_call_screen.dart';
import '../../features/authentication/login/presentation/screen/login_screen.dart';
import '../../features/authentication/register/presentation/screen/register_screen.dart';
import '../../features/chat_module/chat/presentation/screen/chat_screen.dart';
import '../../features/chat_module/chats/model/chat_data.dart';
import '../../features/chat_module/chats/presentation/screen/chats_screen.dart';
import '../utils/safe_print.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    safePrint('generateRoute => ${routeSettings.name}');
    safePrint('generateRoute => ${routeSettings.arguments}');
    switch (routeSettings.name) {
      case RoutingEndpoints.splash:
        return MaterialPageRoute(builder: (_) => const Splash());

      case RoutingEndpoints.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RoutingEndpoints.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case RoutingEndpoints.chats:
        return MaterialPageRoute(builder: (_) => const ChatsScreen());

      case RoutingEndpoints.chat:
        return MaterialPageRoute(builder: (_) {
          final chatData = routeSettings.arguments as ChatData; // Get ChatData
          final roomId = chatData.roomId;
          return  ChatScreen(roomId: roomId,);
        });

      case RoutingEndpoints.videoCall:
        return MaterialPageRoute(
          builder: (_) => const VideoCallScreen()
        );

        case RoutingEndpoints.audioCall:
        return MaterialPageRoute(
          builder: (_) => const AudioCallScreen()
        );

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
