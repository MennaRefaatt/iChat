import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iChat/features/video/constants/agora_constants.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/styles/app_colors.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({super.key});

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _callEnded = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.microphone].request();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: AgoraConstants.appId,
      channelProfile: ChannelProfileType
          .channelProfileCommunication,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
            _callEnded = false;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
            _callEnded = false;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
            _callEnded = true;
          });
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableAudio();

    await _engine.joinChannel(
      token: AgoraConstants.token,
      channelId: AgoraConstants.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: _callEnded
            ? const Text(
                'Call ended',
                style: TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              )
            : _localUserJoined&&_remoteUid != null
                ? Text(
                    'Calling...\n${_remoteUid != null ? '$_remoteUid' : ''}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                : const Text(
                    'Ringing...',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
      ),
      floatingActionButton: _callEnded
          ? FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                setState(() {
                  _callEnded = false;
                  _remoteUid = null;
                  _localUserJoined = false;
                  initAgora();
                });
              },
              backgroundColor: AppColors.green,
              child: const Icon(
                CupertinoIcons.phone,
                color: Colors.white,
              ),
            )
          : FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                setState(() {
                  _engine.leaveChannel();
                  _callEnded = true;
                  _localUserJoined = false;
                  _remoteUid = null;
                });
              },
              backgroundColor: AppColors.red,
              child: const Icon(
                CupertinoIcons.phone_down,
                color: Colors.white,
              ),
            ),
    );
  }
}
