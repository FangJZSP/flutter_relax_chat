import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/common/size_config.dart';
import 'package:relax_chat/manager/log_manager.dart';
import 'package:relax_chat/model/conversation_model.dart';
import 'package:relax_chat/model/ws/resp/ws_msg_model.dart';

import '../../widgets/chat_list/controller/chat_controller.dart';

class ChatState {
  late ChatController chatController;

  StreamSubscription? wsMsgReceiveBus;

  FocusNode focusNode = FocusNode();

  TextEditingController chatEditingController = TextEditingController();

  Rx<ConversationModel> conversation = ConversationModel.fromJson({}).obs;

  RxList<WSMessageModel> messages = RxList<WSMessageModel>.empty();

  final double bottomMargin = SizeConfig.bottomMargin;

  RxDouble chatInputBottomHeight = 0.0.obs;

  String? cursor;

  int pageSize = 20;

  RxBool isLast = false.obs;

  RxInt unreadMessageCount = 0.obs;

  RxBool showLoading = true.obs;

  ChatState() {
    if (Get.arguments != null && Get.arguments is ChatPageArgs) {
      ChatPageArgs args = Get.arguments;
      conversation.value = args.conversation;
    } else {
      logger.d('进入会话错误');
    }
  }
}

class ChatPageArgs {
  ConversationModel conversation;

  ChatPageArgs({
    required this.conversation,
  });
}
