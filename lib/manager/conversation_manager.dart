import 'dart:async';

import 'package:get/get.dart';

import '../model/msg_model.dart';
import '../model/resp/conversation_list_resp.dart';
import '../model/conversation_model.dart';
import '../model/ws/resp/ws_msg_model.dart';
import '../network/api_manager.dart';
import '../network/result.dart';
import 'event_bus_manager.dart';
import 'log_manager.dart';

/// 会话
class ConversationManager {
  ConversationManager._() {
    // 构造器调用时可初始化
    logger.d('ConversationManager init');
    state.newMsgReceiveBus = eventBus.on<WSReceivedMsgEvent>().listen((event) {
      onReceiveMsg(event.model);
    });
  }

  static ConversationManager get instance =>
      _instance ??= ConversationManager._();
  static ConversationManager? _instance;

  ConversationState state = ConversationState();

  void reset() {
    // state.newMsgReceiveBus?.cancel();
  }

  void enterConversation(ConversationModel conversation) {
    state.inConversation = conversation;
  }

  void exitConversation() {
    state.inConversation = null;
  }

  void onReceiveMsg(WSMessageModel wsMsg) {
    logger.d('会话${wsMsg.msg.roomId}收到新消息');

    /// 不在房间里则更新未读消息，在房间里则不更新
    if (state.inConversation?.roomId != wsMsg.msg.roomId) {
      state.conversationUnreadList
          .firstWhereOrNull((element) => element.roomId == wsMsg.msg.roomId)
          ?.unreadMsgCount += 1;
    }
    ConversationModel? model = state.conversations
        .firstWhereOrNull((element) => element.roomId == wsMsg.msg.roomId);
    if (wsMsg.msg.msgType == MessageModelType.text.code) {
      model?.text = wsMsg.msg.body.content;
    }
    model?.activeTime = wsMsg.msg.sendTime;

    /// 调用refresh通知监听者刷新
    state.conversations.refresh();
  }

  void refreshConversationList() async {
    Result<ConversationListResp> result = await api.getConversationList();
    state.conversations.value = result.data?.list ?? [];
    state.conversationUnreadList.addAll(state.conversations
        .map((e) => ConversationUnread(e.roomId, 0))
        .toList());
  }
}

class ConversationState {
  RxList<ConversationModel> conversations = RxList<ConversationModel>.empty();

  List<ConversationUnread> conversationUnreadList = [];

  StreamSubscription? newMsgReceiveBus;

  ConversationModel? inConversation;
}

class ConversationUnread {
  int roomId;
  int unreadMsgCount;

  ConversationUnread(this.roomId, this.unreadMsgCount);
}
