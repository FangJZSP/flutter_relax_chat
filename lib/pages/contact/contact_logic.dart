import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:relax_chat/model/resp/friend_list_resp.dart';
import 'package:relax_chat/model/room_model.dart';
import 'package:relax_chat/model/widget/contact_type_model.dart';
import '../../manager/contact_manager.dart';
import '../../route/routes.dart';
import '../chat/chat_state.dart';
import '../profile/profile_state.dart';
import 'contact_state.dart';

class ContactLogic extends GetxController {
  final ContactState state = ContactState();

  @override
  void onInit() {
    super.onInit();
    initTypeData();
  }

  void initTypeData() {
    state.contacts.add(ContactData<FriendModel>(
      contactType: ContactTypeModel.fromJson({})
        ..desc = ContactType.friend.desc
        ..id = ContactType.friend.code,
      dataList: state.friends,
    ));
    state.contacts.add(ContactData<RoomModel>(
      contactType: ContactTypeModel.fromJson({})
        ..desc = ContactType.groupChat.desc
        ..id = ContactType.groupChat.code,
      dataList: state.groupRooms,
    ));
  }

  /// 刷新好友列表
  Future<void> refreshFriendList() async {
    await ContactManager.instance.refreshFriendList();
    state.contacts
        .firstWhereOrNull(
            (element) => element.contactType.desc == ContactType.friend.desc)
        ?.refreshController
        .finishRefresh();
  }

  /// 刷新群聊列表
  Future<void> refreshGroupRoomList() async {
    await ContactManager.instance.refreshGroupRoomList();
    state.contacts
        .firstWhereOrNull(
            (element) => element.contactType.desc == ContactType.groupChat.desc)
        ?.refreshController
        .finishRefresh();
  }

  void goProfile(FriendModel friend) {
    Get.toNamed(
      Routes.profile,
      arguments: ProfilePageArgs(user: friend.wrapAsUser),
    );
  }

  void goChat(RoomModel room) {
    Get.toNamed(
      Routes.chat,
      arguments: ChatPageArgs(conversation: room.wrapAsConversation),
    );
  }

  void onScrollToPage(int page) {
    state.selectedType.value = page;
  }

  void onSelectType(int index) {
    state.selectedType.value = index;
    state.pageController.jumpToPage(state.selectedType.value);
  }
}
