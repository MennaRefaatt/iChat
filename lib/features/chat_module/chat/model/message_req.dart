import 'package:freezed_annotation/freezed_annotation.dart';
part 'message_req.g.dart';

@JsonSerializable()
class MessageReq {
  String message;
  final String createdAt;
  @JsonKey(name: 'userId')
  String id;
  String roomId; // Added roomId field for request

  MessageReq({
    required this.message,
    required this.id,
    required this.createdAt,
    required this.roomId, // Required field for roomId
  });

  Map<String, dynamic> toJson() => _$MessageReqToJson(this);
}
