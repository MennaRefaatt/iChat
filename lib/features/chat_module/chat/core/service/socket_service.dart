import 'package:iChat/features/chat_module/chat/core/service/socket_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../../core/utils/safe_print.dart';

class SocketService {
  late IO.Socket socket;

  void initSocket() {
    safePrint('Initializing Socket...');
    socket = IO.io(SocketConstants.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true, // Enable reconnection
      'reconnectionAttempts': 5, // Try to reconnect 5 times
      'reconnectionDelay': 1000, // Try reconnecting after 1 second
    });

    // Listen for the 'chat message' event
    socket.on('chat message', (data) {
      safePrint('New message: $data');
    });

    socket.onConnect((_) {
      safePrint('Connected to the chat server');
    });

    socket.onDisconnect((_) {
      safePrint('Disconnected from the chat server');
    });
    socket.onReconnectAttempt((_) {
      safePrint('Attempting to reconnect...');
    });

    socket.onReconnect((_) {
      safePrint('Successfully reconnected');
    });
    socket.onError((error) {
      safePrint('Connection error: $error');
    });
  }

  void sendMessage(dynamic message) {
    safePrint('Sending message: $message');
    socket.emit('chat message', message);
  }

  void dispose() {
    socket.dispose();
  }
}
