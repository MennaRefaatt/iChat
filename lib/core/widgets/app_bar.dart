import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iChat/core/styles/app_colors.dart';
import 'package:iChat/core/utils/navigators.dart';

import '../../features/video/manager/video_call_cubit.dart';
import '../routing/routing_endpoints.dart';

class DefaultAppBar extends StatelessWidget {
  DefaultAppBar(
      {super.key,
      required this.text,
      required this.backArrow,
      this.audioCallIcon,
      this.videoCallIcon});
  final String text;
  final bool? backArrow;
  final bool? audioCallIcon;
  final bool? videoCallIcon;
  List<Color> colors = [
    AppColors.primary,
  ];
  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      height: 60.h,
      blur: 1,
      elevation: 6,
      color: AppColors.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          backArrow == true
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    CupertinoIcons.chevron_back,
                  ),
                )
              : const SizedBox(),
          text.isEmpty
              ? const Expanded(child: SizedBox())
              : Expanded(
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          audioCallIcon == false || videoCallIcon == false
              ? const SizedBox()
              : Row(children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.phone),
                  ),
                  IconButton(
                    onPressed: () {
                      pushNamed(context, RoutingEndpoints.videoCall);
                      context.read<VideoCallCubit>();
                    },
                    icon: const Icon(CupertinoIcons.videocam),
                  ),
                ])
        ],
      ),
    );
  }
}
