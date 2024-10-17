import 'package:flutter/material.dart';
import '../../../../../core/shared_preferences/my_shared.dart';
import '../../../../../core/shared_preferences/my_shared_keys.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/widgets/app_bar.dart';
import '../../core/service/socket_service.dart';
import '../../manager/chat_cubit.dart';
import '../widget/chat_bar.dart';
import '../widget/chat_content.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SocketService _socketService = SocketService();
  late final ChatCubit chatCubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _socketService.initSocket();
    chatCubit = ChatCubit(_socketService);
    chatCubit.fetchMessages();
    chatCubit.stream.listen((state) {
      if (state is ChatMessagesLoaded) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _socketService.dispose();
    chatCubit.messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary.withOpacity(0.1),
      body: Column(
        children: [
          DefaultAppBar(
            text: SharedPref.getString(key: MySharedKeys.userName).toString(),
            audioCallIcon: true,
            videoCallIcon: true,
            backArrow: true,
          ),
          ChatContent(
            chatCubit: chatCubit,
            scrollController: _scrollController,
          ),
          ChatBar(chatCubit: chatCubit, scrollToBottom: _scrollToBottom),
        ],
      ),
    );
  }
}
