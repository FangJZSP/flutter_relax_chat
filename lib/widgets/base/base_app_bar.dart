import 'package:flutter/material.dart';
import '../../common/common.dart';

class BaseAppBar extends StatelessWidget {
  final Widget child;
  final bool needTopMargin;

  const BaseAppBar({required this.child, this.needTopMargin = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: needTopMargin ? SizeConfig.topMargin : 0),
      height: SizeConfig.navBarHeight,
      color: Styles.appBarColor.withOpacity(0.5),
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
