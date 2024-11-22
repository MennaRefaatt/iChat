import 'package:flutter/material.dart';
import 'package:iChat/features/chat_module/chats/presentation/widget/chats_listview.dart';
import '../../model/chat_data.dart';
import '../../service/chat_sevice.dart';
import '../widget/chats_app_bar.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late ChatService _chatService;
  final List<ChatData> _chats = [];
  List<ChatData> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(roomId:"22");
  }

  void _searchChats(String query) {
    setState(() {
      _filteredChats = _chats
          .where((chat) =>
              chat.userId.toLowerCase().contains(query.toLowerCase()) ||
              chat.message.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChatsAppBar(onSearch: _searchChats),
            ChatsListView(
                chats: _chats,
                chatService: _chatService,
                filteredChats: _filteredChats)
          ],
        ),
      ),
    );
  }
}
