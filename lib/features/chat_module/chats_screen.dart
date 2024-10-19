import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iChat/core/extensions/spacing.dart';
import 'package:iChat/core/utils/navigators.dart';
import '../../core/routing/routing_endpoints.dart';
import '../../core/widgets/app_bar.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.black,
      // appBar: AppBar(
      //     title: const BlurryContainer(
      //         blur: 10.0, color: AppColors.purple, child: Text("Chats"))),
      body: SingleChildScrollView(
        child: Column(
          children: [
             DefaultAppBar(text: "Chats", backArrow: false, videoCallIcon: false, audioCallIcon: false,),
            Container(
              margin: EdgeInsets.all(8.sp),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 20,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(10.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: ()=>pushNamed(context, RoutingEndpoints.chat,),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30.sp,
                                  backgroundImage: const NetworkImage(
                                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                                ),
                                horizontalSpacing(10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                           Expanded(child: Text("data",style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.sp,
                                          ),)),
                                          Text("12:00 PM",
                                              style: TextStyle(fontSize: 10.sp)),
                                        ],
                                      ),
                                      const Text("data"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 0.2,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
