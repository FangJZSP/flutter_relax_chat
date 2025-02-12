import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/model/ws/resp/ws_msg_model.dart';
import 'package:relax_chat/widgets/base/base_page.dart';

import '../../common/styles.dart';

import '../../widgets/list_view_chat/view/chat_widget.dart';
import 'chat_logic.dart';
import '../../widgets/chat_input.dart';
import '../../widgets/msg_cell.dart';
import '../../model/widget/message_cell_model.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final logic = Get.put(ChatLogic());
  final state = Get.find<ChatLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: logic.onTapBg,
        child: BasePage(
          pageTitle: state.conversation.value.name,
          needLeading: true,
          onTapLeading: logic.back,
          mainContent: SafeArea(
            child: _chatWidget(context),
          ),
        ),
      );
    });
  }

  Widget _chatWidget(BuildContext context) {
    return Column(
      children: [
        Expanded(child: chatList(context)),
      ],
    );
  }

  Widget chatList(BuildContext context) {
    return Obx(() {
      return ChatWidget(
        chatController: state.chatController,
        roomId: state.conversation.value.roomId,
        inputTextFocusNode: state.focusNode,
        pinBuilder: _pinBuilder,
        outDismiss: logic.onTapBg,
        loadingView: const CircularProgressIndicator(),
        showLoading: state.showLoading.value,
        backgroundColor: Colors.white,
        customerBottomBuilder: _buildBottom,
        onRefresh: state.isLast.value ? null : logic.getMessageList,
        onLoad: null,
        messageItemBuilder: messageItemBuilder,
        toBottomTipFloat: toBottomTipFloatWidget(),
        pageHeadBuilder: (BuildContext context) {},
      );
    });
  }

  Widget _pinBuilder(BuildContext ctx) {
    return const SizedBox();
  }

  Widget _buildBottom(BuildContext ctx) {
    return buildBottomBar();
  }

  Widget? messageItemBuilder(
      BuildContext context, MessageCellModel model, int index) {
    return Column(
      children: [
        _cell(model.messageModel),
      ],
    );
  }

  Widget _cell(WSMessageModel model) {
    return MsgCell(
      model: model,
    );
  }

  Widget toBottomTipFloatWidget() {
    return const SizedBox();
    // return Obx(() {
    //   return Visibility(
    //       visible: state.unreadMessageCount.value <= 0 &&
    //           !state.chatController.bottomNear,
    //       child: Text('跳转底部'));
    // });
  }

  Widget unreadTipFloatWidget() {
    return const SizedBox();
    // return Obx(() {
    //   return Visibility(
    //       visible: state.unreadMessageCount.value > 0 &&
    //           !state.chatController.bottomNear,
    //       child: Text('新消息'));
    // });
  }

  Widget buildBottomBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Styles.grey.withOpacity(0.2),
            offset: const Offset(0, -1),
            blurRadius: 1.0,
            spreadRadius: 0.0,
            blurStyle: BlurStyle.outer,
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ChatInput(
              focusNode: state.focusNode,
              editingController: state.chatEditingController,
              sendCallback: logic.sendTextMsg,
            ),
          ),
        ],
      ),
    );
  }
}
