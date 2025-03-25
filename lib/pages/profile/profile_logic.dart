import 'package:get/get.dart';

import 'profile_state.dart';

class ProfileLogic extends GetxController {
  final ProfileState state = ProfileState();

  @override
  void onInit() {
    super.onInit();
    state.scrollController.addListener(listerScroll);
  }

  void listerScroll() {
    state.offset = state.scrollController.offset;
    double val = state.offset / state.avatarHeight;
    if (val > 1) {
      state.scrollColorOpacity.value = 1;
    } else if (val < 0) {
      state.scrollColorOpacity.value = 0;
    } else {
      state.scrollColorOpacity.value = val;
    }
  }
}
