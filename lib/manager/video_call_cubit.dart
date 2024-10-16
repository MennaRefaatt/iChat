import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../core/service/agora_service.dart';

part 'video_call_state.dart';

class VideoCallCubit extends Cubit<VideoCallState> {
  VideoCallCubit(this.agoraService) : super(VideoCallInitial());
  final AgoraService agoraService;

  Future<void> initializeAgora() async {
    await agoraService.init();
    agoraService.setEventHandler(
      onJoinChannelSuccess: (int uid) {
        if (state is LocalUserJoined) {
          emit((state as LocalUserJoined).copyWith(localUserJoined: true));
        } else {
          emit(LocalUserJoined(localUserJoined: true));
        }
      },
      onUserJoined: (int remoteUid) {
        if (state is LocalUserJoined) {
          emit((state as LocalUserJoined).copyWith(remoteUid: remoteUid));
        } else {
          emit(RemoteUserJoined(remoteUid: remoteUid));
        }
      },
      onUserOffline: (int remoteUid) {
        if (state is LocalUserJoined) {
          emit((state as LocalUserJoined).copyWith(remoteUid: null));
        }
      },
    );
    await agoraService.joinChannel();
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
