import 'package:dio/dio.dart';
import '../../chat/core/service/socket_constants.dart';
import '../model/chat_data.dart';

class ChatService {
  final Dio _dio = Dio();
  String roomId;

  ChatService({required this.roomId});

  Stream<List<ChatData>> fetchChatsStream() async* {
    while (true) {
      try {
        final response = await _dio.get('${SocketConstants.chatBaseUrl}${SocketConstants.chatMessageEndpoint}$roomId');
        if (response.statusCode == 200) {
          final chatList = List<Map<String, dynamic>>.from(response.data);
          List<ChatData> chats = chatList.map((chat) => ChatData.fromJson(chat)).toList();
          yield chats;
        } else {
          throw Exception("Failed to load chats");
        }
      } catch (e) {
        print("Error fetching chats: $e");
        yield []; // In case of error, return an empty list
      }
    }
  }
}
