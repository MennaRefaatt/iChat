import 'package:meta/meta.dart';

@immutable
abstract class VideoCallState {}

final class VideoCallInitial extends VideoCallState {}

final class LocalUserJoined extends VideoCallState {
  final bool localUserJoined;
  final int? remoteUid;

  LocalUserJoined({this.localUserJoined = false, this.remoteUid});
}

final class RemoteUserJoined extends VideoCallState {
  final int remoteUid;
  final bool localUserJoined;

  RemoteUserJoined({required this.remoteUid, this.localUserJoined = false});
}

final class RemoteUserLeft extends VideoCallState {
  final int remoteUid;

  RemoteUserLeft(this.remoteUid);
}

final class LocalUserLeft extends VideoCallState {}

final class AgoraError extends VideoCallState {
  final String message;

  AgoraError(this.message);
}
