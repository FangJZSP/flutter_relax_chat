import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:relax_chat/helper/toast_helper.dart';
import 'package:relax_chat/model/resp/apply_resp.dart';
import 'package:relax_chat/network/result.dart';

import '../../network/api_manager.dart';
import 'apply_state.dart';

class ApplyLogic extends GetxController {
  final ApplyState state = ApplyState();

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onClose() {
    super.onClose();
    state.txtController.dispose();
    state.focusNode.dispose();
  }

  void onTapBg() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> apply() async {
    if (state.inputStr.isEmpty) {
      showTipsToast('请填写申请信息哦😊～');
      return;
    }
    Result<ApplyResp>? result;
    if (state.groupRoom != null) {
      result = await api.applyGroup(
          roomId: state.groupRoom!.roomId, message: state.inputStr.value);
    } else if (state.user != null) {
      result = await api.applyFriend(
          friendId: state.user!.uid.toString(), message: state.inputStr.value);
    }
    if (result?.ok == true && result?.data?.success == true) {
      showTipsToast('申请成功～');
      Get.back();
    } else {
      showTipsToast('申请失败，${result?.message}～');
    }
  }
}
