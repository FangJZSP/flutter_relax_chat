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
    state.contacts.add(ContactData(
      contactType: ContactTypeModel.fromJson({})
        ..name = ContactType.friend.desc
        ..id = ContactType.friend.code,
      friendList: state.friends,
    ));
    state.contacts.add(ContactData(
      contactType: ContactTypeModel.fromJson({})
        ..name = ContactType.groupChat.desc
        ..id = ContactType.groupChat.code,
      friendList: state.friends,
    ));
  }

  /// 加载好友列表
  Future<void> refreshFriendList({bool isRefresh = true}) async {
    await ContactManager.instance.refreshFriendList(isRefresh: isRefresh);
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
    if (state.selectedType.value == index) {
      return;
    }
    state.selectedType.value = index;
    state.pageController
        .animateToPage(state.selectedType.value,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut)
        .then((value) {});
  }
}
