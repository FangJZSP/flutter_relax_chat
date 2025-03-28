import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:relax_chat/helper/toast_helper.dart';
import 'package:relax_chat/model/room_model.dart';
import 'package:relax_chat/model/user_model.dart';
import 'package:relax_chat/network/api_manager.dart';
import 'package:relax_chat/pages/apply/apply_state.dart';

import '../../model/resp/group_room_list_resp.dart';
import '../../model/resp/user_list_resp.dart';
import '../../network/result.dart';
import '../../route/routes.dart';
import 'add_state.dart';

class AddLogic extends GetxController {
  final AddState state = AddState();

  @override
  void onInit() {
    super.onInit();
    state.focusNode.requestFocus();
  }

  @override
  void onClose() {
    super.onClose();
    state.focusNode.dispose();
    state.txtController.dispose();
  }

  void findPerson() {
    clearInput();
    state.findType.value = FindType.person;
  }

  void findGroup() {
    clearInput();
    state.findType.value = FindType.group;
  }

  void clearInput() {
    state.txtController.clear();
    state.inputStr.value = '';
  }

  Future<void> searchFind() async {
    if (state.inputStr.isEmpty) {
      showTipsToast('输入不能为空哦～');
      return;
    }
    showLoadingToast();
    if (state.findType.value == FindType.group) {
      state.findGroups.clear();
      Result<GroupRoomListResp> result =
          await api.groupSearch(name: state.inputStr.value);
      if (result.ok) {
        state.findGroups.addAll(result.data?.list ?? []);
        state.findGroups.refresh();
      }
    } else {
      state.findPeople.clear();
      Result<UserListResp> result =
          await api.friendSearch(name: state.inputStr.value);
      if (result.ok) {
        state.findPeople.addAll(result.data?.list ?? []);
        state.findPeople.refresh();
      }
    }
    cleanAllToast();
  }

  void addFind({
    RoomModel? room,
    UserModel? user,
  }) {
    Get.toNamed(
      Routes.apply,
      arguments: ApplyPageArgs(
        state.findType.value,
        groupRoom: room,
        user: user,
      ),
    );
  }

  void onTapBg() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
