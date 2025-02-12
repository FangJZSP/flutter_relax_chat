import 'package:get/get.dart';

import '../../manager/dialog_task_manager.dart';
import '../../manager/event_bus_manager.dart';
import '../../route/routes.dart';
import 'home_state.dart';

class HomeLogic extends GetxController {
  final HomeState state = HomeState();

  @override
  void onInit() {
    super.onInit();
    state.backToRouteEventBus = eventBus.on<BackToRouteEvent>().listen((event) {
      if (Get.currentRoute == Routes.root) {
        DialogTaskManager.instance.start();
      }
    });
  }

  void changeTabIndex(int tabIndex) {
    if (tabIndex >= state.tabCount) {
      state.tabIndex.value = state.tabCount - 1;
    } else {
      state.lastTabIndex.value = state.tabIndex.value;
      state.tabIndex.value = tabIndex;
      if (tabIndex == HomeSubPage.messagePage.tab) {
      } else if (tabIndex == HomeSubPage.contactPage.tab) {}
    }
  }
}
