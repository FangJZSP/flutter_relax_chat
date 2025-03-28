import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:relax_chat/model/room_model.dart';
import 'package:relax_chat/model/user_model.dart';

import '../../manager/log_manager.dart';
import '../add/add_state.dart';

class ApplyState {
  FindType applyType = FindType.person;
  RoomModel? groupRoom;
  UserModel? user;

  TextEditingController txtController = TextEditingController();
  FocusNode focusNode = FocusNode();
  RxString inputStr = ''.obs;

  ApplyState() {
    if (Get.arguments != null && Get.arguments is ApplyPageArgs) {
      ApplyPageArgs args = Get.arguments;
      applyType = args.type;
      groupRoom = args.groupRoom;
      user = args.user;
    } else {
      logger.d('进入申请页面错误');
    }
  }
}

class ApplyPageArgs {
  final FindType type;
  final RoomModel? groupRoom;
  final UserModel? user;

  ApplyPageArgs(
    this.type, {
    this.groupRoom,
    this.user,
  });
}
