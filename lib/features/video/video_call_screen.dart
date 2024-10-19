import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iChat/core/styles/app_colors.dart';
import 'package:iChat/core/utils/safe_print.dart';
import 'package:iChat/core/widgets/app_bar.dart';
import 'package:iChat/features/video/constants/agora_constants.dart';
import 'manager/video_call_cubit.dart';
import 'manager/video_call_state.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late int uid;

  @override
  void initState() {
    super.initState();
    uid = DateTime.now()
        .microsecondsSinceEpoch
        .remainder(100000);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<VideoCallCubit>().initializeAgora(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DefaultAppBar(
            text: "Video Call",
            backArrow: false,
            videoCallIcon: false,
            audioCallIcon: false,
          ),
          BlocBuilder<VideoCallCubit, VideoCallState>(
            builder: (context, state) {
              if (state is LocalUserJoined) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      _remoteVideo(context, state.remoteUid),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 120.w,
                          height: 120.h,
                          child: Center(
                            child: AgoraVideoView(
                              controller: VideoViewController(
                                rtcEngine: context
                                    .read<VideoCallCubit>()
                                    .agoraService
                                    .engine,
                                canvas: VideoCanvas(uid: 0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CircleAvatar(
                          backgroundColor: AppColors.red,
                          child: IconButton(
                            onPressed: () =>
                                context.read<VideoCallCubit>().leaveChannel(),
                            icon: const Icon(
                              CupertinoIcons.phone_down,
                              color: AppColors.greyInput,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is AgoraError) {
                safePrint("Error: ${state.message}");
                return Center(child: Text(state.message));
              }
              if (state is LocalUserLeft || state is RemoteUserLeft) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: CircleAvatar(
                    backgroundColor: AppColors.green,
                    child: IconButton(
                      onPressed: () =>
                          context.read<VideoCallCubit>().initializeAgora(uid),
                      icon: const Icon(CupertinoIcons.videocam,
                          color: AppColors.primaryLight),
                    ),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  Widget _remoteVideo(BuildContext context, int? remoteUid) {
    if (remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: context.read<VideoCallCubit>().agoraService.engine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(
            channelId: AgoraConstants.channelName,
            localUid: uid,
          ),
        ),
      );
    } else {
      return const Center(child: Text('Waiting for remote user to join'));
    }
  }
}
