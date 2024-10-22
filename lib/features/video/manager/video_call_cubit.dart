import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iChat/features/video/manager/video_call_state.dart';
import '../../../core/service/agora_service.dart';
import '../constants/agora_constants.dart';

class VideoCallCubit extends Cubit<VideoCallState> {
  VideoCallCubit(this.agoraService) : super(VideoCallInitial());
  final AgoraService agoraService;

  Future<void> initializeAgora(int uid) async {
    await agoraService.initialize();
    agoraService.setEventHandler(
      onJoinChannelSuccess: (int uid) {
        emit(LocalUserJoined(
          localUserJoined: true,
          remoteUid: uid,
        ));
      },
      onUserJoined: (int remoteUid) {
        emit(RemoteUserJoined(remoteUid: remoteUid));
      },
      onUserOffline: (int remoteUid) {
        emit(RemoteUserLeft(remoteUid));
      },

    );
    await agoraService.joinChannel(
        AgoraConstants.token, AgoraConstants.channelName, uid);
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