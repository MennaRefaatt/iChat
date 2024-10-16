import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iChat/manager/video_call_cubit.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agora Video Call')),
      body: BlocBuilder<VideoCallCubit, VideoCallState>(
        builder: (context, state) {
          return Stack(
            children: [
              Center(child: _remoteVideo(context, state)),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 100,
                  height: 150,
                  child: Center(
                    child: state is LocalUserJoined
                        ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: context.read<VideoCallCubit>().agoraService.engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    )
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo(BuildContext context, VideoCallState state) {
    if (state is RemoteUserJoined) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: context.read<VideoCallCubit>().agoraService.engine,
          canvas: VideoCanvas(uid: state.remoteUid),
          connection: const RtcConnection(channelId: 'iChat'),
        ),
      );
    } else {
      return const Text('Waiting for remote user to join', textAlign: TextAlign.center);
    }
  }
}
