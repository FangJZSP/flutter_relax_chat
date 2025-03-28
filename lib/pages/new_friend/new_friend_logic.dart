import 'dart:async';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:relax_chat/helper/toast_helper.dart';
import 'package:relax_chat/manager/contact_manager.dart';
import '../../network/api_manager.dart';
import '../../route/routes.dart';
import 'new_friend_state.dart';

class NewFriendLogic extends GetxController {
  final NewFriendState state = NewFriendState();

  void goAdd() {
    Get.toNamed(Routes.add);
  }

  @override
  void onInit() {
    super.onInit();
    refreshNewFriendList();
  }

  @override
  void onClose() {
    state.refreshController.dispose();
    super.onClose();
  }

  Future<void> refreshNewFriendList({bool isRefresh = true}) async {
    if (state.isLoading.value) return;

    if (isRefresh) {
      state.currentPage = 1;
      state.hasMore.value = true;
    }

    if (!state.hasMore.value && !isRefresh) {
      state.refreshController.finishLoad(IndicatorResult.noMore);
      return;
    }

    state.isLoading.value = true;
    final result = await api.getFriendApplyList(
      page: state.currentPage,
      size: state.size,
    );

    if (result.ok) {
      if (isRefresh) {
        state.applyList.clear();
      }

      state.applyList.addAll(result.data?.list ?? []);
      state.hasMore.value = (result.data?.size ?? 0) < state.size;
      state.currentPage++;

      if (isRefresh) {
        state.refreshController.finishRefresh();
      } else {
        state.refreshController.finishLoad(
          state.hasMore.value
              ? IndicatorResult.success
              : IndicatorResult.noMore,
        );
      }
    } else {
      if (isRefresh) {
        state.refreshController.finishRefresh();
      } else {
        state.refreshController.finishLoad();
      }
    }

    state.isLoading.value = false;
  }

  Future<void> approve(String friendId, bool isApprove) async {
    showLoadingToast();
    final result = await api.approveFriend(
      friendId: friendId,
      isApprove: isApprove,
    );

    if (result.ok) {
      refreshNewFriendList(isRefresh: true);
      ContactManager.instance.refreshFriendList();
    }
    cleanAllToast();
  }
}
