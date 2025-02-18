import 'package:get/get.dart';
import '../model/resp/friend_list_resp.dart';
import '../network/api_manager.dart';
import 'log_manager.dart';

/// 联系人
class ContactManager {
  ContactManager._() {
    logger.d('FriendManager init');
  }

  static ContactManager get instance => _instance ??= ContactManager._();
  static ContactManager? _instance;

  FriendState state = FriendState();

  void dispose() {
    state.friends.clear();
  }

  /// 刷新好友列表
  Future<void> refreshFriendList({bool isRefresh = true}) async {
    if (isRefresh) {
      state.currentPage = 1;
      state.nextCursor = null;
      state.hasMore.value = true;
    }
    if (!state.hasMore.value || state.isLoading.value) return;

    state.isLoading.value = true;
    final result = await api.getFriendList(
      page: state.currentPage,
      size: state.pageSize,
      cursor: state.nextCursor,
    );

    if (result.ok) {
      if (isRefresh) {
        state.friends.clear();
      }
      state.friends.addAll(result.data?.list ?? []);
      state.nextCursor = result.data?.cursor ?? '';
      state.hasMore.value = result.data?.cursor != null;
      state.currentPage++;
    }
    state.isLoading.value = false;
  }
}

class FriendState {
  // 好友列表数据
  final RxList<FriendModel> friends = <FriendModel>[].obs;

  // 是否正在加载
  final RxBool isLoading = false.obs;

  // 是否还有更多数据
  final RxBool hasMore = true.obs;

  // 当前页码
  int currentPage = 1;

  // 每页大小
  final int pageSize = 20;

  // 下一页游标
  String? nextCursor;

  FriendState();
}
