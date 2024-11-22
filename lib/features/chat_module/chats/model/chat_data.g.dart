// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatData _$ChatDataFromJson(Map<String, dynamic> json) => ChatData(
      message: json['message'] as String,
      createdAt: json['createdAt'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userImage: json['userImage'] as String,
      isRead: json['isRead'] as bool? ?? false,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      roomId: json['roomId'] as String,
    );

Map<String, dynamic> _$ChatDataToJson(ChatData instance) => <String, dynamic>{
      'message': instance.message,
      'createdAt': instance.createdAt,
      'userId': instance.userId,
      'userName': instance.userName,
      'userImage': instance.userImage,
      'roomId': instance.roomId,
      'isRead': instance.isRead,
      'unreadCount': instance.unreadCount,
    };
