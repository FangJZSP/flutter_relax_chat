import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import '../../model/resp/group_apply_list_resp.dart';

class GroupNoticeState {
  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  RxList<GroupApplyModel> applyList = <GroupApplyModel>[].obs;

  // 分页相关
  int currentPage = 1;
  int size = 20;
  final RxBool hasMore = true.obs;
  final RxBool isLoading = false.obs;

  GroupNoticeState();
}
