import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:iChat/core/utils/safe_print.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../features/video/constants/agora_constants.dart';

class AgoraService {
  late RtcEngine engine;

  Future<void> initialize() async {
    await [Permission.microphone, Permission.camera].request();

    engine = createAgoraRtcEngine();
    await engine.initialize(
      const RtcEngineContext(
        appId: AgoraConstants.appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );
    await engine.enableVideo();
    await engine.startPreview();
  }

  Future<void> joinChannel(String token, String channelName, int uid) async {
    try {
      await engine.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: const ChannelMediaOptions(),
      );
    } on AgoraRtcException catch (e) {
      safePrint("Error joining channel: ${e.code}, ${e.message}");
      rethrow;
    }
  }

  Future<void> leaveChannel() async {
    try {
      await engine.leaveChannel();
    } catch (e) {
      safePrint("Error leaving channel: $e");
    }
  }

  Future<void> enableVideo() async {
    await engine.enableVideo();
  }

  Future<void> disableVideo() async {
    await engine.disableVideo();
  }

  Future<void> dispose() async {
    await engine.leaveChannel();
    await engine.release();
  }

  void setEventHandler({
    required Function(int) onJoinChannelSuccess,
    required Function(int) onUserJoined,
    required Function(int) onUserOffline,
  }) {
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          safePrint("Local user ${connection.localUid} joined the channel.");
          onJoinChannelSuccess(connection.localUid!);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          safePrint("Remote user $remoteUid joined the channel.");
          onUserJoined(remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          safePrint("Remote user $remoteUid left the channel.");
          onUserOffline(remoteUid);
        },
      ),
    );
  }
}