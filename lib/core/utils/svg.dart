import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../styles/app_colors.dart';

class AppSVG extends StatelessWidget {
  const AppSVG({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.color,
  });

  final String assetName;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    String assetPath = assetName;
    if (!assetPath.contains('svg')) {
      assetPath = "assets/svg/"+assetPath + '.svg';
    }
    
    return SvgPicture.asset(
      assetPath,
      height: height,
      width: width,
      colorFilter: color == null ? const ColorFilter.mode(AppColors.black, BlendMode.srcIn) : ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    );
  }
}
