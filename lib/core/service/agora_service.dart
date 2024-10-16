import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  final String appId;
  final String token;
  final String channelName;
  late RtcEngine _engine;

  AgoraService({required this.appId, required this.token, required this.channelName});

  Future<void> init() async {
    // Request permissions
    await [Permission.microphone, Permission.camera].request();

    // Initialize the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    await _engine.enableVideo();
    await _engine.startPreview();
  }

  // Add a getter for the Agora engine
  RtcEngine get engine => _engine;

  Future<void> joinChannel() async {
    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
  }

  void setEventHandler({
    required Function(int) onUserJoined,
    required Function(int) onUserOffline,
    required Function(int) onJoinChannelSuccess,
  }) {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          onJoinChannelSuccess(connection.localUid!);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          onUserJoined(remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          onUserOffline(remoteUid);
        },
      ),
    );
  }

  Future<void> dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }
}
