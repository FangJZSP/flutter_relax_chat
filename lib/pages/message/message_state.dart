import 'package:relax_chat/manager/conversation_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:relax_chat/model/conversation_model.dart';

class MessageState {
  RxList<ConversationModel> get conversations =>
      ConversationManager.instance.state.conversations;

  List<ConversationUnread> get conversationUnreadList =>
      ConversationManager.instance.state.conversationUnreadList;

  MessageState() {
    ///Initialize variables
  }
}
