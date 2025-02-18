import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:relax_chat/helper/toast_helper.dart';
import 'package:get/get.dart';
import 'package:relax_chat/model/user_model.dart';
import 'package:relax_chat/network/result.dart';

import '../../manager/user_manager.dart';
import '../../manager/event_bus_manager.dart';
import '../../manager/log_manager.dart';
import '../../model/msg_body_model.dart';
import '../../model/msg_model.dart';
import '../../model/req/text_msg_req.dart';
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

    state.chatController = ChatController(
      jumpToBottomCallback: () {},
      inputFocusNode: state.focusNode,
    );

    state.chatInputBottomHeight.value = state.bottomMargin;

    state.focusNode.addListener(() {
      if (state.focusNode.hasFocus) {
        state.chatInputBottomHeight.value = 0;
      } else {
        state.chatInputBottomHeight.value = state.bottomMargin;
      }
    });

    getMessageList();

    state.wsMsgReceiveBus = eventBus.on<WSReceivedMsgEvent>().listen((event) {
      _onReceiveMsg(event.model);
    });
  }

  @override
  void onClose() {
    state.chatController.dispose();
    state.wsMsgReceiveBus?.cancel();
    super.onClose();
  }

  void onTapBg() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> getMessageList() async {
    if (state.isLast.value) {
      return;
    }
    state.showLoading.value = true;
    Result<MessageListResp> result = await api.getMessageList(
      roomId: state.conversation.value.roomId,
      cursor: state.cursor,
      size: 20,
    );

    /// 保存分页数据
    state.cursor = result.data?.cursor;
    state.isLast.value = result.data?.isLast ?? false;

    /// 列表反转加入消息列表
    state.messages.addAll(result.data?.list.reversed ?? []);
    List<MessageCellModel> msgCells = state.messages
        .map((element) => MessageCellModel(
            messageModel: element, msgCellType: MessageCellType.addOld))
        .toList();
    _handleNewMsgList(msgCells);
    state.showLoading.value = false;
  }

  void _onReceiveMsg(WSMessageModel msg) {
    if (msg.senderIsMe) {
      return;
    }
    logger.d('聊天页面收到新消息');
    _handleNewMsgList([
      MessageCellModel.fromJson({})
        ..messageModel = msg
        ..msgCellType = MessageCellType.addNew
    ]);
  }

  /// 处理消息，将list插入消息数据源中，
  void _handleNewMsgList(List<MessageCellModel> list) {
    list = list.reversed.toList();
    updateMessage(list);
  }

  void updateMessage(dynamic message) {
    state.chatController.updateMessage(message);
  }

  Future<void> sendTextMsg(String message) async {
    TextMsgReq textMsgReq = TextMsgReq.fromJson({})..content = message;

    UserModel me = UserManager.instance.state.user.value;

    MessageBodyModel messageBodyModel = MessageBodyModel.fromJson({})
      ..content = message;
    MessageModel messageModel = MessageModel.fromJson({})
      ..body = messageBodyModel
      ..msgType = MessageModelType.text.code
      ..messageId =
          '${UserManager.instance.state.user.value.uid}${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(10000)}'
      ..status = MessageStatus.delivering.code
      ..senderAvatar = me.avatar
      ..senderId = me.uid
      ..senderName = me.name;

    WSMessageModel wsMessageModel = WSMessageModel(messageModel);

    _handleNewMsgList([
      MessageCellModel.fromJson({})
        ..messageModel = wsMessageModel
        ..msgCellType = MessageCellType.addNew
    ]);

    Result<WSMessageModel> result = await api.sendMsg(
      roomId: state.conversation.value.roomId,
      msgType: MessageModelType.text.code,
      body: {
        'content': message,
        if (textMsgReq.replyMsgId != null) 'replyMsgId': textMsgReq.replyMsgId,
        'atUidList': textMsgReq.atUidList,
      },
    );

    if (result.ok) {
      _handleNewMsgList([
        MessageCellModel.fromJson({})
          ..messageModel =
              WSMessageModel(messageModel..status = MessageStatus.succeed.code)
          ..msgCellType = MessageCellType.update
      ]);
    } else {
      showTipsToast(result.message ?? '发送消息失败～');
      _handleNewMsgList([
        MessageCellModel.fromJson({})
          ..messageModel =
              WSMessageModel(messageModel..status = MessageStatus.failed.code)
          ..msgCellType = MessageCellType.update
      ]);
    }
  }

  void back() {
    Get.back(result: state.conversation.value.roomId);
  }
}
