import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iChat/core/shared_preferences/my_shared.dart';
import 'package:iChat/core/shared_preferences/my_shared_keys.dart';
import 'package:iChat/core/utils/safe_print.dart';
import 'package:iChat/features/video/manager/video_call_state.dart';
import '../../../core/service/agora_service.dart';
import '../constants/agora_constants.dart';

class VideoCallCubit extends Cubit<VideoCallState> {
  VideoCallCubit(this.agoraService) : super(VideoCallInitial());
  final AgoraService agoraService;
  int? _remoteUid;
  Future<void> initializeAgora() async {
    await agoraService.initialize();
    agoraService.setEventHandler(
      onJoinChannelSuccess: (int uid) {
        emit(LocalUserJoined(
          localUserJoined: true,
          remoteUid: _remoteUid,
        ));
      },
      onUserJoined: (int remoteUid) {
        _remoteUid = remoteUid;
        emit(RemoteUserJoined(remoteUid: remoteUid));
      },
      onUserOffline: (int remoteUid) {
        _remoteUid = 0;
        remoteUid = 0;
        emit(RemoteUserLeft(remoteUid));
      },
    );
    String? userId = SharedPref.getString(key: MySharedKeys.userId);
    if (userId == null) {
      throw Exception("Missing user ID for video call");
    }
    try {
      int uid = int.parse(userId);
      await agoraService.joinChannel(
          AgoraConstants.token, AgoraConstants.channelName, uid);
    } catch (e) {
      safePrint("Error parsing user ID: $e");
    }
  }

  Future<void> leaveChannel() async {
    await agoraService.leaveChannel();
    emit(VideoCallInitial());
  }

  @override
  Future<void> close() async {
    await agoraService.dispose();
    super.close();
  }
}