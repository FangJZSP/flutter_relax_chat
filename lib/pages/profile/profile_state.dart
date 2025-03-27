import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:relax_chat/common/common.dart';
import '../../manager/log_manager.dart';
import '../../model/user_model.dart';

class ProfileState {
  Rx<UserModel> user = UserModel.fromJson({}).obs;

  final ScrollController scrollController = ScrollController();

  final scrollPhysics =
      const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());

  // 修改这里，增加展开高度
  double expandedHeight = 120.w;

  double avatarHeight = 80.w;

  RxDouble scrollColorOpacity = 0.0.obs;

  ProfileState() {
    if (Get.arguments != null && Get.arguments is ProfilePageArgs) {
      ProfilePageArgs args = Get.arguments;
      user.value = args.user;
    } else {
      logger.d('进入个人资料错误');
    }
  }
}

class ProfilePageArgs {
  final UserModel user;

  ProfilePageArgs({required this.user});
}
