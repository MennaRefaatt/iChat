import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iChat/features/chat_module/chats/presentation/widget/chats_listview.dart';
import '../../model/chat_data.dart';
import '../../service/chat_sevice.dart';
import '../widget/chats_app_bar.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late ChatService _chatService;
  final List<ChatData> _chats = [];
  List<ChatData> _filteredChats = [];
  late TextEditingController _searchController;
  late Timer _debounce;

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(roomId:"22");
    _searchController = TextEditingController();
    _debounce = Timer(Duration.zero, () {}); // Initialize debounce timer
  }

  void _searchChats(String query) {
    if (_debounce.isActive) {
      _debounce.cancel();
    }

    // Set a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _filteredChats = _chats
            .where((chat) =>
        chat.userId.toLowerCase().contains(query.toLowerCase()) ||
            chat.message.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChatsAppBar(onSearch: _searchChats,
                searchController: _searchController),
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
