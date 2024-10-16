part of 'video_call_cubit.dart';

@immutable
sealed class VideoCallState {}

// Initial state before any actions take place
final class VideoCallInitial extends VideoCallState {}

// State when the local user has joined the channel
final class LocalUserJoined extends VideoCallState {
  final bool localUserJoined;
  final int? remoteUid;

  LocalUserJoined({this.localUserJoined = false, this.remoteUid});

  // Add copyWith method
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

// State when a remote user has joined
final class RemoteUserJoined extends VideoCallState {
  final int remoteUid;
  final bool localUserJoined;

  RemoteUserJoined({required this.remoteUid, this.localUserJoined = false});

  // Add copyWith method
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

// State when a remote user has left the channel
final class RemoteUserLeft extends VideoCallState {
  final int remoteUid;

  RemoteUserLeft(this.remoteUid);

  // Add copyWith method
  RemoteUserLeft copyWith({int? remoteUid}) {
    return RemoteUserLeft(remoteUid ?? this.remoteUid);
  }
}

// State when the local user has left the channel
final class LocalUserLeft extends VideoCallState {}

// State when an error or any Agora-related issue occurs
final class AgoraError extends VideoCallState {
  final String message;

  AgoraError(this.message);

  // Add copyWith method
  AgoraError copyWith({String? message}) {
    return AgoraError(message ?? this.message);
  }
}
