import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relax_chat/manager/log_manager.dart';
import 'package:relax_chat/model/conversation_model.dart';
import '../../widgets/chat_list/controller/chat_controller.dart';

class ChatState {
  late ChatController chatController;

  StreamSubscription? wsMsgReceiveBus;

  FocusNode focusNode = FocusNode();

  TextEditingController chatEditingController = TextEditingController();

  Rx<ConversationModel> conversation = ConversationModel.fromJson({}).obs;

  RxDouble chatInputBottomHeight = 0.0.obs;

  String? cursor;

  int page = 1;

  int pageSize = 20;

  RxBool isLast = false.obs;

  RxInt unreadMessageCount = 0.obs;

  RxBool showLoading = true.obs;

  ImagePicker picker = ImagePicker();

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
