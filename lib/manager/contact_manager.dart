import 'package:get/get.dart';
import 'package:relax_chat/model/room_model.dart';
import '../model/resp/friend_list_resp.dart';
import '../network/api_manager.dart';
import 'log_manager.dart';

/// 联系人
class ContactManager {
  ContactManager._() {
    logger.d('ContactManager init');
  }

  static ContactManager get instance => _instance ??= ContactManager._();
  static ContactManager? _instance;

  ContactManagerState state = ContactManagerState();

  void reset() {
    state.friends.clear();
    state.groupRooms.clear();
  }

  /// 刷新好友列表
  Future<void> refreshFriendList() async {
    if (state.isFriendLoading.value) {
      return;
    }
    state.isFriendLoading.value = true;
    final result = await api.getFriendList();

    if (result.ok) {
      state.friends.clear();
      state.friends.addAll(result.data?.list ?? []);
    }
    state.isFriendLoading.value = false;
  }

  /// 刷新群聊列表
  Future<void> refreshGroupRoomList() async {
    if (state.isGroupLoading.value) {
      return;
    }
    state.isGroupLoading.value = true;
    final result = await api.getGroupRoomsList();

    if (result.ok) {
      state.groupRooms.clear();
      state.groupRooms.addAll(result.data?.list ?? []);
    }
    state.isGroupLoading.value = false;
  }
}

class ContactManagerState {
  // 好友列表
  final RxList<FriendModel> friends = <FriendModel>[].obs;

  // 群聊列表
  final RxList<RoomModel> groupRooms = <RoomModel>[].obs;

  // 是否正在加载
  final RxBool isFriendLoading = false.obs;

  final RxBool isGroupLoading = false.obs;

  ContactManagerState();
}
