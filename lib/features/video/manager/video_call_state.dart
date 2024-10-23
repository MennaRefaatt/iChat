part of 'video_call_cubit.dart';

@immutable
abstract class VideoCallState {}

class VideoCallInitial extends VideoCallState {}

class VideoCallSuccess extends VideoCallState {}

class VideoCallError extends VideoCallState {
  final String message;
  VideoCallError(this.message);
}

class VideoCallUserJoined extends VideoCallState {
  final int remoteUid;
  VideoCallUserJoined(this.remoteUid);
}

class VideoCallUserLeft extends VideoCallState {}

class VideoCallEnd extends VideoCallState {}
