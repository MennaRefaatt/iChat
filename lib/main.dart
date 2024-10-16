import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iChat/chats_screen.dart';
import 'package:iChat/manager/video_call_cubit.dart';
import 'package:iChat/video_call_screen.dart';
import 'core/service/agora_service.dart';

void main() {
  final agoraService = AgoraService(
    appId: "2da7f6dc3e64422eac930d421f2d7067",
    token:
        "007eJxTYOC/u71Hts7vrljXuSM3j7zXChN23dlg7OVscftV9e7qw7sVGIxSEs3TzFKSjVPNTEyMjFITky2NDVJMjAzTjFLMDczMK7bzpzcEMjJoOL1lZWSAQBCflSHTOSOxhIEBALUCIEM=",
    channelName: "iChat",
  );

  runApp(
    MyApp(agoraService: agoraService),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.agoraService});

  final AgoraService agoraService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => ChatsScreen(),
        '/videoCall': (context) => BlocProvider(
              create: (context) =>
                  VideoCallCubit(agoraService)..initializeAgora(),
              child: const VideoCallScreen(),
            ), // Define the route for ChatScreen
      },
    );
  }
}
