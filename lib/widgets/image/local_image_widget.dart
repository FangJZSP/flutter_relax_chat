import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  const MyImage({
    required this.imgUrl,
    this.width,
    this.height,
    this.color,
    this.fit,
    this.alignment = Alignment.center,
    this.cacheWidth,
    this.cacheHeight,
    super.key,
  });

  final String imgUrl;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imgUrl,
      width: width,
      height: height,
      color: color,
      fit: fit,
      alignment: alignment,
      cacheWidth: cacheWidth ?? (width == null ? null : width!.toInt() * 3),
      cacheHeight: cacheHeight ?? (height == null ? null : height!.toInt() * 3),
    );
  }
}
