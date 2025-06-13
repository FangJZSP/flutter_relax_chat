import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:relax_chat/common/size_config.dart';

class MyNetworkImage extends StatelessWidget {
  final String imgUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const MyNetworkImage(
      {required this.imgUrl, this.width, this.height, this.fit, super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      imgUrl,
      width: width ?? 20.w,
      height: height ?? 20.w,
      fit: fit ?? BoxFit.fill,
    );
  }
}
