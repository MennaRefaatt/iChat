import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    required this.textStyle,
    this.width,
    this.height,
    this.borderRadius
  });
final double? width;
  final double? height;
  final double? borderRadius;
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: SizedBox(
        width: width??double.infinity,
        height: height??60.h,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius??15.sp),
            ),
          ),
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
