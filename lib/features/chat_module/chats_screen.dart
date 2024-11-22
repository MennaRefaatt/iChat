import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iChat/core/extensions/spacing.dart';
import 'package:iChat/core/utils/navigators.dart';
import 'package:iChat/core/routing/routing_endpoints.dart';
import 'package:iChat/core/utils/safe_print.dart';
import 'package:iChat/core/widgets/app_bar.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'chat/core/service/socket_constants.dart';

class ChatService {
  final Dio _dio = Dio();

  Stream<List<ChatData>> fetchChatsStream() async* {
    while (true) {
      try {
        final response = await _dio.get(
            '${SocketConstants.chatBaseUrl}${SocketConstants.chatMessageEndpoint}/:1');
        if (response.statusCode == 200) {
          final chatList = List<Map<String, dynamic>>.from(response.data);

          // Group chats by userId and select the latest message per userId
          Map<String, ChatData> uniqueChats = {};

          for (var chat in chatList) {
            final chatData = ChatData.fromJson(chat);
            if (uniqueChats.containsKey(chatData.userId)) {
              if (uniqueChats[chatData.userId]!.time.compareTo(chatData.time) < 0) {
                uniqueChats[chatData.userId] = chatData;
              }
            } else {
              uniqueChats[chatData.userId] = chatData;
            }
          }

          // Sort the chats by time in descending order (latest chat first)
          List<ChatData> sortedChats = uniqueChats.values.toList();
          sortedChats.sort((a, b) => b.time.compareTo(a.time)); // Compare in descending order

          // Yield the sorted list of unique chats ordered by the latest message
          yield sortedChats;
        } else {
          throw Exception("Failed to load chats");
        }
      } catch (e) {
        safePrint("Error fetching chats: $e");
        yield []; // In case of error, return an empty list
      }
    }
  }
}

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _chatService = ChatService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DefaultAppBar(
              text: "Chats",
              backArrow: false,
              videoCallIcon: false,
              audioCallIcon: false,
            ),
            StreamBuilder<List<ChatData>>(
              stream: _chatService.fetchChatsStream(),
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

                final chats = snapshot.data!;

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: chats.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return ChatItem(
                      chatData: chat,
                      onTap: () => pushNamed(
                        context,
                        RoutingEndpoints.chat,
                        arguments: chat, // Pass the chat data to the next screen
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(thickness: 0.5),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatData {
  final String message;
  final String time;
  final String userId;
  bool isRead; // Field to track if the chat is read
  late final int unreadCount; // Field to track the number of unread messages

  ChatData({
    required this.message,
    required this.time,
    required this.userId,
    this.isRead = false,
    this.unreadCount = 0, // Default is 0 unread messages
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      message: json['message'],
      time: json['createdAt'],
      userId: json['userId'],
      isRead: json['isRead'] ?? false,
      unreadCount: json['unreadCount'] ?? 0, // Ensure this is handled from JSON
    );
  }

  // Method to mark the chat as read and reset the unread count
  void markAsRead() {
    isRead = true;
    unreadCount = 0;
  }
}


class ChatItem extends StatelessWidget {
  final ChatData chatData;
  final VoidCallback onTap;

  const ChatItem({super.key, required this.chatData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Format the time to "3:04 PM"
    String formattedTime = _formatTime(chatData.time);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.sp),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.sp,
              backgroundImage: const NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzk92qOx7c5k5fybjVbUkwg6BGW_ptjgID9A&s"),
            ),
            horizontalSpacing(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chatData.userId,
                          style: TextStyle(
                            fontWeight: chatData.isRead ? FontWeight.normal : FontWeight.bold,
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                      Text(
                        formattedTime,
                        style: TextStyle(fontSize: 10.sp,
                        color: chatData.isRead ? Colors.grey : Colors.green),
                      ),
                    ],
                  ),
                  Text(chatData.message), // Display the message preview
                ],
              ),
            ),
            if (chatData.unreadCount > 0) // Only show unread count if it's greater than 0
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  child: Text(
                    '${chatData.unreadCount}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    return DateFormat('h:mm a').format(dateTime);
  }
}


