import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iChat/core/extensions/spacing.dart';
class ChatsAppBar extends StatelessWidget {
  final Function(String) onSearch;

  const ChatsAppBar({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpacing(40.h),
          Text(
            'Chats',
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: const TextStyle(fontWeight: FontWeight.w300),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(color: Colors.grey.shade100),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(color: Colors.grey.shade100),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              prefixIcon: const Icon(CupertinoIcons.search),
            ),
          )
        ],
      ),
    );
  }
}