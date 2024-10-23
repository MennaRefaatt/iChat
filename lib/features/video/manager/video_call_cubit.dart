import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/service/agora_service.dart';
import '../constants/agora_constants.dart';

part 'video_call_state.dart';

class VideoCallCubit extends Cubit<VideoCallState> {
  VideoCallCubit() : super(VideoCallInitial());
  int? remoteUid;
  bool localUserJoined = false;
  late RtcEngine engine;
  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: AgoraConstants.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
            localUserJoined = true;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
            remoteUid = remoteUid;
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
            remoteUid = 0;
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: AgoraConstants.token,
      channelId: AgoraConstants.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> dispose() async {
    await engine.leaveChannel();
    await engine.release();
  }

}
