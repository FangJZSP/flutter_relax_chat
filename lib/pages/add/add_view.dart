import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:relax_chat/pages/add/add_state.dart';
import 'package:relax_chat/widgets/base/base_app_bar.dart';

import '../../common/common.dart';
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                selectSegment(),
                Positioned(
                  left: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget selectSegment() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: logic.findPerson,
            child: Container(
              decoration: BoxDecoration(
                border: const Border(
                  top: BorderSide(color: Styles.black),
                  left: BorderSide(color: Styles.black),
                  bottom: BorderSide(color: Styles.black),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2.w),
                  bottomLeft: Radius.circular(2.w),
                ),
                color: state.findType.value == FindType.person
                    ? Styles.black
                    : Styles.white,
              ),
              padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
              child: Text(
                '找人',
                style: Styles.textNormal(12.w).copyWith(
                    color: state.findType.value == FindType.person
                        ? Styles.white
                        : Styles.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: logic.findGroup,
            child: Container(
              decoration: BoxDecoration(
                border: const Border(
                  top: BorderSide(color: Styles.black),
                  right: BorderSide(color: Styles.black),
                  bottom: BorderSide(color: Styles.black),
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(2.w),
                  bottomRight: Radius.circular(2.w),
                ),
                color: state.findType.value == FindType.group
                    ? Styles.black
                    : Styles.white,
              ),
              padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
              child: Text('找群',
                  style: Styles.textNormal(12.w).copyWith(
                      color: state.findType.value == FindType.group
                          ? Styles.white
                          : Styles.black)),
            ),
          ),
        ],
      );
    });
  }
}
