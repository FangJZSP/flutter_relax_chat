import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import '../../network/api_manager.dart';
import 'group_notice_state.dart';

class GroupNoticeLogic extends GetxController {
  final GroupNoticeState state = GroupNoticeState();

  @override
  void onInit() {
    super.onInit();
    refreshGroupApplyList();
  }

  @override
  void onClose() {
    state.refreshController.dispose();
    super.onClose();
  }

  Future<void> refreshGroupApplyList({bool isRefresh = true}) async {
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
    final result = await api.getGroupApplyList(
      page: state.currentPage,
      size: state.size,
    );

    if (result.ok) {
      if (isRefresh) {
        state.applyList.clear();
      }

      final list = result.data?.list ?? [];
      state.applyList.addAll(list);
      state.hasMore.value = list.length >= state.size;
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
        state.refreshController.finishRefresh(IndicatorResult.fail);
      } else {
        state.refreshController.finishLoad(IndicatorResult.fail);
      }
    }

    state.isLoading.value = false;
  }
}
