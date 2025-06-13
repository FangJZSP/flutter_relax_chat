import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relax_chat/manager/user_manager.dart';

import '../../helper/file_upload_helper.dart';
import '../../helper/toast_helper.dart';
import '../../manager/dialog_task_manager.dart';
import '../../manager/event_bus_manager.dart';
import '../../network/api_manager.dart';
import '../../network/result.dart';
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

  void openDrawer() {
    state.scaleFoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    state.scaleFoldKey.currentState?.closeDrawer();
  }

  void logout() {
    UserManager.instance.logOut();
  }

  /// 选择并上传头像
  Future<void> pickAndUploadAvatar() async {
    final XFile? image =
        await state.picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // 显示加载提示
      showLoadingToast();

      // 上传文件
      String avatar = await FileUploadHelper.uploadToMinio(image.path);

      if (avatar.isEmpty) {
        showTipsToast('头像上传失败');
        return;
      }

      // 更新用户头像
      Result result = await api.updateUserInfo(avatar: avatar);
      if (result.ok) {
        showTipsToast('头像更新成功');
      } else {
        showTipsToast('头像更新失败');
      }
    }
  }
}
