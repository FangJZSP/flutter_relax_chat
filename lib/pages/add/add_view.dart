import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/widgets/base/base_app_bar.dart';

import 'add_logic.dart';

class AddPage extends StatelessWidget {
  AddPage({super.key});

  final logic = Get.put(AddLogic());
  final state = Get.find<AddLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BaseAppBar(
              child: Row(children: [
            Text('找人'),
            Text('找群'),
          ])),
        ],
      ),
    );
  }
}
