import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/common/common.dart';

import 'profile_state.dart';

class ProfileLogic extends GetxController {
  final ProfileState state = ProfileState();

  @override
  void onInit() {
    super.onInit();
    state.scrollController.addListener(listerScroll);
  }

  void listerScroll() {
    double offset = state.scrollController.offset;
    double compare = state.expandedHeight - kToolbarHeight;
    double val = offset / compare;
    if (val > 1) {
      state.scrollColorOpacity.value = 1;
    } else if (val < 0) {
      state.scrollColorOpacity.value = 0;
    } else {
      state.scrollColorOpacity.value = val;
    }
  }

  void back() {
    Get.back();
  }
}
