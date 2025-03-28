import 'package:flutter/material.dart';
import '../../common/common.dart';

class BaseAppBar extends StatelessWidget {
  final Widget child;
  final bool needTopMargin;
  final Color? appBarColor;

  const BaseAppBar({
    required this.child,
    this.needTopMargin = true,
    this.appBarColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: needTopMargin ? SizeConfig.topMargin : 0),
      height: SizeConfig.navBarHeight,
      color: appBarColor ?? Styles.appBarColor,
      child: Column(
        children: [
          Expanded(
            child: child,
          ),
          Divider(
            color: Styles.grey.withOpacity(0.1),
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
