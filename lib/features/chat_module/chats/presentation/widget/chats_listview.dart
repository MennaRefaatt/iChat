import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iChat/core/utils/navigators.dart';
import 'package:iChat/core/routing/routing_endpoints.dart';
import '../../model/chat_data.dart';
import '../../service/chat_sevice.dart';
import 'chat_item.dart';

class ChatsListView extends StatelessWidget {
  ChatsListView({
    super.key,
    required this.chats,
    required this.chatService,
    required this.filteredChats,
  });
  final ChatService chatService;
   List<ChatData> filteredChats;
   List<ChatData> chats;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatData>>(
      stream: chatService.fetchChatsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: TextStyle(fontSize: 14.sp),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "No chats available.",
              style: TextStyle(fontSize: 14.sp),
            ),
          );
        }
        chats = snapshot.data!;
        filteredChats = chats; // Initially, no filter is applied

        return ListView.separated(
          shrinkWrap: true,
          itemCount: filteredChats.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final chat = filteredChats[index];
            return ChatItem(
              chatData: chat,
              onTap: () => pushNamed(
                context,
                RoutingEndpoints.chat,
                arguments: chat,
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(thickness: 0.5),
        );
      },
    );
  }
}
