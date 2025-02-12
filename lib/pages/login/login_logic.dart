import 'package:get/get.dart';

import '../../route/routes.dart';
import 'login_state.dart';

class LoginLogic extends GetxController {
  final LoginState state = LoginState();

  void goEmailLogin() {
    Get.toNamed(Routes.emailLogin);
  }

  void back() {
    Get.back();
  }
}
