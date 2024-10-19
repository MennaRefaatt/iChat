import 'package:meta/meta.dart';

@immutable
abstract class VideoCallState {}

final class VideoCallInitial extends VideoCallState {}

final class LocalUserJoined extends VideoCallState {
  final bool localUserJoined;
  final int? remoteUid;

  LocalUserJoined({this.localUserJoined = false, this.remoteUid});

  LocalUserJoined copyWith({
    bool? localUserJoined,
    int? remoteUid,
  }) {
    return LocalUserJoined(
      localUserJoined: localUserJoined ?? this.localUserJoined,
      remoteUid: remoteUid ?? this.remoteUid,
    );
  }
}

final class RemoteUserJoined extends VideoCallState {
  final int remoteUid;
  final bool localUserJoined;

  RemoteUserJoined({required this.remoteUid, this.localUserJoined = false});

  RemoteUserJoined copyWith({
    int? remoteUid,
    bool? localUserJoined,
  }) {
    return RemoteUserJoined(
      remoteUid: remoteUid ?? this.remoteUid,
      localUserJoined: localUserJoined ?? this.localUserJoined,
    );
  }
}

final class RemoteUserLeft extends VideoCallState {
  final int remoteUid;

  RemoteUserLeft(this.remoteUid);

  RemoteUserLeft copyWith({int? remoteUid}) {
    return RemoteUserLeft(remoteUid ?? this.remoteUid);
  }
}

final class LocalUserLeft extends VideoCallState {}

final class AgoraError extends VideoCallState {
  final String message;

  AgoraError(this.message);

  AgoraError copyWith({String? message}) {
    return AgoraError(message ?? this.message);
  }
}
