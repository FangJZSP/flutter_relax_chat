import 'package:get/get.dart';
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
    state.conversations.listen((v) {
      update();
    });
  }

  void goChat(ConversationModel conversation) {
    clearConversationUnread(conversation.roomId);
    Get.toNamed(Routes.chat,
        arguments: ChatPageArgs(conversation: conversation));
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
