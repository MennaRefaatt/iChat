import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:iChat/core/utils/safe_print.dart';
import 'package:meta/meta.dart';
import '../core/service/socket_constants.dart';
import '../core/service/socket_service.dart';
import '../model/message.dart';
import '../model/message_req.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SocketService _socketService;
  final String roomId;
  List<MessageModel> messages = [];
  TextEditingController messageController = TextEditingController();

  ChatCubit(this._socketService, this.roomId) : super(ChatInitial()) {
    _socketService.joinRoom(roomId);
    _socketService.listenToRoom(roomId, (newMessage) {
      messages.add(MessageModel.fromJson(newMessage));
      emit(ChatMessagesLoaded(List.from(messages)));
    });
    fetchMessages();
  }
  void markMessageAsRead(String messageId) {
    final message = messages.firstWhere((msg) => msg.id == messageId);
    if (message != null && !message.isRead) {
      message.isRead = true;
      emit(ChatMessagesLoaded(List.from(messages)));
    }
  }
  Future<void> fetchMessages() async {
    emit(ChatLoading());
    try {
      final response = await Dio().get(
          '${SocketConstants.chatBaseUrl}${SocketConstants.chatMessageEndpoint}$roomId');
      if (response.statusCode == 200) {
        messages = (response.data as List)
            .map((e) => MessageModel.fromJson(e))
            .toList();
        emit(ChatMessagesLoaded(messages));
      } else {
        emit(ChatError('Failed to load messages'));
      }
    } catch (e) {
      emit(ChatError('Error fetching messages: $e'));
    }
  }

  Future<void> sendMessage({required MessageReq message}) async {
    try {
      final response = await Dio().post(
        '${SocketConstants.chatBaseUrl}${SocketConstants.chatMessageEndpoint}$roomId',
        data: message.toJson(),
      );
      if (response.statusCode == 201) {
        _socketService.sendMessage(roomId, message.toJson());
      } else {
        emit(ChatError('Failed to send message'));
      }
    } catch (e) {
      emit(ChatError('Error sending message: $e'));
    }
  }
}
