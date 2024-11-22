import 'package:json_annotation/json_annotation.dart';
part 'chat_data.g.dart';
@JsonSerializable()
class ChatData {
  final String message;
  final String createdAt; // Changed from 'time' to match 'createdAt'
  final String userId;
  final String userName;
  final String userImage;
  final String roomId;
  bool isRead; // Track if the chat is read
  late final int unreadCount; // Track the number of unread messages

  ChatData({
    required this.message,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.userImage,
    this.isRead = false,
    this.unreadCount = 0,
    required this.roomId, // Default is 0 unread messages
  });

  // Factory constructor to create a ChatData instance from JSON
  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      message: json['message'],
      createdAt: json['createdAt'], // 'createdAt' to match 'MessageModel'
      userId: json['userId'],
      userName: json['userName'], // Add userName field to the model
      userImage: json['userImage'], // Add userImage field to the model
      isRead: json['isRead'] ?? false,
      unreadCount: json['unreadCount'] ?? 0,
      roomId: json['roomId'], // Ensure this is handled from JSON
    );
  }

  // Convert the ChatData instance to a JSON object
  Map<String, dynamic> toJson() => _$ChatDataToJson(this);

  // Method to mark the chat as read and reset unread count
  void markAsRead() {
    isRead = true;
    unreadCount = 0;
  }
}