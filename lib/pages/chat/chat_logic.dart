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
    state.chatInputBottomHeight.value = state.bottomMargin;
    state.chatController = ChatController(
      jumpToBottomCallback: () {},
      inputFocusNode: state.focusNode,
    );
    state.focusNode.addListener(() {
      if (state.focusNode.hasFocus) {
        state.chatInputBottomHeight.value = 0;
      } else {
        state.chatInputBottomHeight.value = state.bottomMargin;
      }
    });
    state.wsMsgReceiveBus = eventBus.on<WSReceivedMsgEvent>().listen((event) {
      _onReceiveMsg(event.model);
    });
    getMessageList();
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

  void onTapBack() {
    Get.back(result: state.conversation.value.roomId);
  }

  Future<void> getMessageList() async {
    if (state.isLast.value) {
      return;
    }
    // state.showLoading.value = true;
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
              messageModel: element,
              msgCellType: MessageCellType.addOld,
            ))
        .toList();
    _handleNewMsgList(msgCells);
    state.showLoading.value = false;
  }

  Future<void> loadMessageList() async {
    if (state.isLast.value) {
      return;
    }
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
              messageModel: element,
              msgCellType: MessageCellType.addOld,
            ))
        .toList();
    _handleNewMsgList(msgCells);
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

    // 构建消息body
    MessageBodyModel messageBodyModel = MessageBodyModel.fromJson({})
      ..content = message;

    // 构建消息model
    MessageModel messageModel = MessageModel.fromJson({})
      ..body = messageBodyModel
      ..msgType = MessageModelType.text.code
      ..senderAvatar = me.avatar
      ..senderId = me.uid
      ..senderName = me.name;

    // 构建ws消息model
    WSMessageModel wsMessageModel = WSMessageModel(messageModel);

    // 构建ui消息model
    MessageCellModel messageCellModel = MessageCellModel.fromJson({})
      ..messageModel = wsMessageModel
      ..messageId =
          '${UserManager.instance.state.user.value.uid}${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(10000)}'
      ..msgCellType = MessageCellType.addNew
      ..status = MessageStatus.delivering.code;

    // 处理ui消息model
    _handleNewMsgList([messageCellModel]);

    // 发送文本消息
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
        messageCellModel
          ..msgCellType = MessageCellType.update
          ..status = MessageStatus.succeed.code
      ]);
    } else {
      showTipsToast(result.message ?? '发送消息失败～');
      _handleNewMsgList([
        messageCellModel
          ..msgCellType = MessageCellType.update
          ..status = MessageStatus.failed.code
      ]);
    }
  }
}
