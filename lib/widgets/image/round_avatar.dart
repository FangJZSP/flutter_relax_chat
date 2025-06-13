import 'package:flutter/material.dart';
import 'package:relax_chat/widgets/image/local_image_widget.dart';

import '../../common/images.dart';
import 'network_image_widget.dart';

class RoundAvatar extends StatefulWidget {
  final double height;
  final String? url;
  final Decoration? borderDecoration;

  const RoundAvatar(
      {required this.height, super.key, this.url, this.borderDecoration});

  @override
  RoundAvatarState createState() => RoundAvatarState();
}

class RoundAvatarState extends State<RoundAvatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        width: widget.height,
        decoration: widget.borderDecoration,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(widget.height / 2.0),
              child: buildContent(),
            ),
          ],
        ));
  }

  Widget buildContent() {
    if (widget.url != null && widget.url!.isNotEmpty) {
      return MyNetworkImage(
        imgUrl: widget.url!,
        width: widget.height,
        height: widget.height,
      );
    } else {
      return MyImage(
        imgUrl: ImageNames.avatar,
        width: widget.height,
        height: widget.height,
        fit: BoxFit.fitHeight,
      );
    }
  }
}
