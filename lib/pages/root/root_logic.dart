import 'package:get/get.dart';
import 'package:relax_chat/manager/global_manager.dart';
import '../../route/routes.dart';
import '../home/home_logic.dart';
import 'root_state.dart';

class RootLogic extends GetxController {
  final RootState state = RootState();

  @override
  void onReady() {
    super.onReady();
    Get.toNamed(GlobalManager.instance.state.firstRoute);
  }

  void backToHome() {
    if (Get.isRegistered<HomeLogic>()) {
      Get.until((route) => route.settings.name == Routes.home);
    } else {
      Get.offNamedUntil(
        Routes.home,
        (route) => route.settings.name == Routes.root,
      );
    }
  }

  void backToLogin() {
    Get.offNamedUntil(
      Routes.login,
      (route) => route.settings.name == Routes.root,
    );
  }
}
