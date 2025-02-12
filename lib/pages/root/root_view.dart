import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'root_logic.dart';

enum RootSubPage {
  home,
  login,
}

class RootPage extends StatelessWidget {
  RootPage({super.key});

  final logic = Get.put(RootLogic());
  final state = Get.find<RootLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
