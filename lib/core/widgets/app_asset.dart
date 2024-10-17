import 'package:flutter/material.dart';

class AppAssetImage extends StatelessWidget {
  const AppAssetImage(
      {super.key,
      required this.image,
      required this.width,
      required this.height,
      this.topLeftRadius,
      this.topRightRadius,
      this.bottomLeftRadius,
      this.bottomRightRadius,
      this.color,
      this.colorBlendMode,
      this.fit});
  final String image;
  final double width;
  final double height;
  final BoxFit? fit;

  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomLeftRadius;
  final double? bottomRightRadius;
  final Color? color;
  final BlendMode? colorBlendMode;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeftRadius ?? 0),
        topRight: Radius.circular(topRightRadius ?? 0),
        bottomRight: Radius.circular(bottomRightRadius ?? 0),
        bottomLeft: Radius.circular(bottomLeftRadius ?? 0),
      ),
      child: Image.asset(
        color: color,
        colorBlendMode: colorBlendMode,
        "assets/images/$image",
        height: height,
        width: width,
        fit: fit,
      ),
    );
  }
}
