import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyNetworkImage extends StatelessWidget {
  final String imgUrl;
  final double? width;
  final double? height;

  const MyNetworkImage(
      {required this.imgUrl, this.width, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width ?? 20,
      height: height ?? 20,
      fit: BoxFit.fill,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, dynamic err) {
        return const Icon(Icons.error_outline);
      },
      imageUrl: imgUrl,
    );
  }
}
