import 'package:get/get.dart';
import 'package:relax_chat/manager/conversation_manager.dart';
import 'package:relax_chat/model/conversation_model.dart';
import 'package:relax_chat/pages/chat/chat_state.dart';
import 'package:relax_chat/pages/home/home_logic.dart';
import '../../route/routes.dart';
import 'message_state.dart';

class MessageLogic extends GetxController {
  final MessageState state = MessageState();

  @override
  void onInit() {
    super.onInit();
    state.conversations.listen((p0) {
      update();
    });
  }

  void goChat(ConversationModel conversation) {
    clearConversationUnread(conversation.roomId);
    ConversationManager.instance.enterConversation(conversation);
    Get.toNamed(Routes.chat,
            arguments: ChatPageArgs(conversation: conversation))
        ?.then((value) {
      if (value == conversation.roomId) {
        ConversationManager.instance.exitConversation();
      }
    });
  }

  void clearConversationUnread(int roomId) {
    state.conversationUnreadList
        .firstWhereOrNull((element) => element.roomId == roomId)
        ?.unreadMsgCount = 0;
    update();
  }

  void openDrawer() {
    Get.find<HomeLogic>().openDrawer();
  }
}
