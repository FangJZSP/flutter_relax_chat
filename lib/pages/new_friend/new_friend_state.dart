import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

import '../../model/resp/friend_list_resp.dart';

class NewFriendState {
  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  RxList<FriendModel> applyList = <FriendModel>[].obs;

  // 分页相关
  int currentPage = 1;
  int size = 20;
  final RxBool hasMore = true.obs;
  final RxBool isLoading = false.obs;

  NewFriendState();
}
