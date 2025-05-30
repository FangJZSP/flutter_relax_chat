import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:relax_chat/helper/toast_helper.dart';
import 'package:get/get.dart';
import 'package:relax_chat/model/user_model.dart';
import 'package:relax_chat/network/result.dart';

import '../../manager/conversation_manager.dart';
import '../../manager/user_manager.dart';
import '../../manager/event_bus_manager.dart';
import '../../manager/log_manager.dart';
import '../../model/msg_body_model.dart';
import '../../model/msg_model.dart';
import '../../model/resp/msg_list_resp.dart';
import '../../model/ws/resp/ws_msg_model.dart';
import '../../network/api_manager.dart';

import '../../widgets/chat_list/controller/chat_controller.dart';
import 'chat_state.dart';
import '../../model/widget/message_cell_model.dart';

class ChatLogic extends GetxController {
  final ChatState state = ChatState();

  @override
  void onInit() {
    super.onInit();
    ConversationManager.instance.enterConversation(state.conversation.value);
    state.chatController = ChatController(
      inputFocusNode: state.focusNode,
    );
    state.wsMsgReceiveBus = eventBus.on<WSReceivedMsgEvent>().listen((event) {
      onReceiveMsg(event.model);
    });
    refreshMessageList();
  }

  @override
  void onClose() {
    ConversationManager.instance.exitConversation();
    state.chatController.dispose();
    state.wsMsgReceiveBus?.cancel();
    super.onClose();
  }

  void onTapBg() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onTapBack() {
    Get.back(result: state.conversation.value.roomId);
  }

  Future<void> refreshMessageList() async {
    if (state.isLast.value) {
      return;
    }

    Result<MessageListResp> result = await api.getMessageList(
      roomId: state.conversation.value.roomId,
      cursor: state.cursor,
      page: state.page,
      size: state.pageSize,
    );

    if (result.ok == false) {
      showTipsToast('获取消息列表失败');
      return;
    }

    state.page += 1;
    state.cursor = result.data?.cursor;
    state.isLast.value = result.data?.isLast ?? false;

    List<MessageCellModel> msgCells = (result.data?.list ?? [])
        .map(
          (element) => MessageCellModel.fromJson({})
            ..messageModel = element
            ..msgCellType = MessageCellType.addOld,
        )
        .toList();
    state.chatController.updateMessage(msgCells);
    state.showLoading.value = false;
  }

  Future<void> loadMessageList() async {
    if (state.isLast.value) {
      return;
    }

    Result<MessageListResp> result = await api.getMessageList(
      roomId: state.conversation.value.roomId,
      cursor: state.cursor,
      page: state.page + 1,
      size: state.pageSize,
    );

    if (result.ok == false) {
      showTipsToast('加载消息列表失败');
      return;
    }

    state.page += 1;
    state.cursor = result.data?.cursor;
    state.isLast.value = result.data?.isLast ?? false;

    List<MessageCellModel> msgCells = (result.data?.list ?? [])
        .map(
          (element) => MessageCellModel.fromJson({})
            ..messageModel = element
            ..msgCellType = MessageCellType.addOld,
        )
        .toList();
    state.chatController.updateMessage(msgCells);
  }

  void onReceiveMsg(WSMessageModel wsMessageModel) {
    if (wsMessageModel.senderIsMe ||
        wsMessageModel.msg.roomId != state.conversation.value.roomId) {
      return;
    }
    logger.d('聊天页面收到新消息');
    state.chatController.updateMessage([
      MessageCellModel.fromJson({})
        ..messageModel = wsMessageModel.msg
        ..msgCellType = MessageCellType.addNew
    ]);
  }

  Future<void> sendTextMsg(String message) async {
    UserModel me = UserManager.instance.state.user.value;

    int sendTime = DateTime.now().millisecondsSinceEpoch;

    // 构建消息body
    MessageBodyModel messageBodyModel = MessageBodyModel.fromJson({})
      ..content = message
      ..atUidList = [];

    // 构建消息model
    MessageModel messageModel = MessageModel.fromJson({})
      ..body = messageBodyModel
      ..msgType = MessageModelType.text.code
      ..senderAvatar = me.avatar
      ..senderId = me.uid
      ..senderName = me.name
      ..sendTime = sendTime;

    // 构建ui消息model
    MessageCellModel messageCellModel = MessageCellModel.fromJson({})
      ..messageModel = messageModel
      ..messageId =
          '${UserManager.instance.state.user.value.uid}$sendTime${Random().nextInt(10000)}'
      ..msgCellType = MessageCellType.addNew
      ..status = MessageStatus.delivering.code;

    // 处理ui消息model
    state.chatController.updateMessage([messageCellModel]);

    // 发送文本消息
    Result<WSMessageModel> result = await api.sendMsg(
      roomId: state.conversation.value.roomId,
      msgType: MessageModelType.text.code,
      body: {
        'content': message,
        'replyMsgId': null,
        'atUidList': [],
      },
    );

    if (result.ok) {
      state.chatController.updateMessage([
        messageCellModel
          ..msgCellType = MessageCellType.update
          ..status = MessageStatus.succeed.code
      ]);
    } else {
      showTipsToast(result.message ?? '发送消息失败～');
      state.chatController.updateMessage([
        messageCellModel
          ..msgCellType = MessageCellType.update
          ..status = MessageStatus.failed.code
      ]);
    }
  }
}
