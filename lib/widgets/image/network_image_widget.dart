import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MyNetworkImage extends StatelessWidget {
  final String imgUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const MyNetworkImage({
    required this.imgUrl,
    this.width,
    this.height,
    this.fit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      imgUrl,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
