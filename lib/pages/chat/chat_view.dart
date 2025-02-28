import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/common/size_config.dart';
import 'package:relax_chat/widgets/base/base_page.dart';

import '../../common/styles.dart';

import '../../widgets/chat_list/view/chat_widget.dart';
import '../../widgets/chat_list/view/popup_widget.dart';
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
          onTapLeading: logic.onTapBack,
          mainContent: _chatWidget(context),
        ),
      );
    });
  }

  Widget _chatWidget(BuildContext context) {
    return Container(
      color: Styles.greyBgColor,
      child: Column(
        children: [
          Expanded(child: chatList(context)),
        ],
      ),
    );
  }

  Widget chatList(BuildContext context) {
    return Obx(() {
      return ChatWidget(
        chatController: state.chatController,
        roomId: state.conversation.value.roomId,
        inputTextFocusNode: state.focusNode,
        onTapBg: logic.onTapBg,
        backgroundColor: Styles.white,
        showLoading: state.showLoading.value,
        loadingView: const CircularProgressIndicator(),
        onRefresh: logic.getMessageList,
        onLoad: state.isLast.value ? null : logic.loadMessageList,
        customHeadBuilder: headBuilder,
        customPinBuilder: pinBuilder,
        customBottomBuilder: bottomBuilder,
        customMessageCellBuilder: messageCellBuilder,
        toBottomFloatWidget: toBottomFloatWidget(),
        menuParams: PopupMenuParams(
          backgroundColor: Styles.transparent,
          onMenuShow: (messageCellModel) {},
          getActions: (messageCellModel) {
            return [
              MessageActionType.copy,
              MessageActionType.quote,
              MessageActionType.pin,
              MessageActionType.translate,
            ];
          },
          buildAction: (messageActionType, messageCellModel,
              dynamic Function()? removePop) {
            if (messageActionType == MessageActionType.copy) {
              return Icon(
                Icons.copy_outlined,
                size: 16.w,
              );
            }
            if (messageActionType == MessageActionType.pin) {
              return Icon(
                Icons.upgrade_outlined,
                size: 16.w,
              );
            }
            if (messageActionType == MessageActionType.quote) {
              return Icon(
                Icons.format_quote_outlined,
                size: 16.w,
              );
            }
            if (messageActionType == MessageActionType.translate) {
              return Icon(
                Icons.translate,
                size: 16.w,
              );
            }
            return Container();
          },
          bottomHeight: SizeConfig.bottomMargin,
        ),
      );
    });
  }

  Widget headBuilder(BuildContext ctx) {
    return Container(
      height: 0,
      color: Styles.lightBlue,
    );
  }

  Widget pinBuilder(BuildContext ctx) {
    return Container(
      height: 0,
      color: Styles.normalBlue,
    );
  }

  Widget bottomBuilder(BuildContext ctx) {
    return Obx(() {
      return Container(
        padding:
            EdgeInsets.fromLTRB(10, 0, 10, state.chatInputBottomHeight.value),
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
          borderRadius: BorderRadius.circular(4.w),
          color: Styles.navigationBarColor,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 4.w, 0, 6.w),
          child: Row(
            children: [
              Expanded(
                child: ChatInput(
                  focusNode: state.focusNode,
                  editingController: state.chatEditingController,
                  sendCallback: logic.sendTextMsg,
                  bgColor: Styles.navigationBarColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget messageCellBuilder(
      BuildContext context, MessageCellModel model, int index) {
    return Column(
      children: [
        MsgCell(
          cell: model,
        ),
      ],
    );
  }

  Widget toBottomFloatWidget() {
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
}
