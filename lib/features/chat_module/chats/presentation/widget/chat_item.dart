import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iChat/core/extensions/spacing.dart';
import 'package:intl/intl.dart';
import '../../model/chat_data.dart';

class ChatItem extends StatefulWidget {
  final ChatData chatData;
  final VoidCallback onTap;

  const ChatItem({super.key, required this.chatData, required this.onTap});

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatTime(widget.chatData.createdAt);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        widget.onTap();
        setState(() {
          widget.chatData.unreadCount = (widget.chatData.unreadCount ?? 0) + 1; // Safely increment
        });
      },
      child: Container(
        padding: EdgeInsets.all(10.sp),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.sp,
              backgroundImage: NetworkImage(widget.chatData.userImage),
            ),
            horizontalSpacing(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatData.userName,
                    style: TextStyle(
                      fontWeight: widget.chatData.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                      fontSize: 17.sp,
                    ),
                  ),
                  Text(widget.chatData.message), // Display the message preview
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(
                      fontSize: 10.sp,
                      color:
                          widget.chatData.isRead ? Colors.grey : Colors.green),
                ),
                verticalSpacing(10.h),
                if (widget.chatData.unreadCount! >
                    0) // Only show unread count if it's greater than 0
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.sp, vertical: 4.sp),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      child: Text(
                        '${widget.chatData.unreadCount}',
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
