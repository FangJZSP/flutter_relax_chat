import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'group_notice_logic.dart';

class GroupNoticePage extends StatelessWidget {
  GroupNoticePage({Key? key}) : super(key: key);

  final logic = Get.put(GroupNoticeLogic());
  final state = Get.find<GroupNoticeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
