import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/common/size_config.dart';

import '../../common/styles.dart';

import '../../manager/socket/socket_manager.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.appBarColor,
        title: Row(
          children: [
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.conversation.value.name.isNotEmpty
                        ? state.conversation.value.name
                        : 'Loading',
                    style: Styles.textFiraNormal(14.w)
                        .copyWith(color: Styles.blackText),
                  ),
                  Obx(() {
                    return Text(
                      SocketManager.instance.didConnect.value ? '在线>' : '离线>',
                      style: Styles.textFiraNormal(8.w)
                          .copyWith(color: Styles.blackText),
                    );
                  }),
                ],
              );
            }),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dehaze),
            onPressed: () {},
          ),
          SizedBox(width: SizeConfig.bodyPadding),
        ],
      ),
      body: Obx(() {
        return ChatWidget(
          chatController: state.chatController,
          roomId: state.conversation.value.roomId,
          inputTextFocusNode: state.focusNode,
          backgroundColor: Styles.white,
          showLoading: state.showLoading.value,
          loadingView: const CircularProgressIndicator(),
          onTapBg: logic.onTapBg,
          // onRefresh: logic.refreshMessageList,
          onLoad: state.isLast.value ? null : logic.loadMessageList,
          customHeadBuilder: headBuilder,
          customPinBuilder: pinBuilder,
          customBottomBuilder: bottomBuilder,
          customMessageCellBuilder: messageCellBuilder,
          unreadCountFloatBuilder: null,
          customJumpBottomFloatBuilder: null,
          resizeToAvoidBottomInset: true,
          popupMenuParams: PopupMenuParams(
            menuBgColor: const Color.fromRGBO(80, 85, 87, 1),
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
                return actionWidget(
                  icon: Icons.copy_outlined,
                  actionName: '复制',
                );
              }
              if (messageActionType == MessageActionType.pin) {
                return actionWidget(
                  icon: Icons.upgrade_outlined,
                  actionName: '置顶',
                );
              }
              if (messageActionType == MessageActionType.quote) {
                return actionWidget(
                  icon: Icons.format_quote_outlined,
                  actionName: '引用',
                );
              }
              if (messageActionType == MessageActionType.translate) {
                return actionWidget(
                  icon: Icons.translate,
                  actionName: '翻译',
                );
              }
              return Container();
            },
            bottomHeight: SizeConfig.bottomMargin,
          ),
        );
      }),
    );
  }

  Widget actionWidget({
    required IconData icon,
    required String actionName,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.w,
              color: Styles.white,
            ),
            Text(
              actionName,
              style:
                  Styles.textFiraNormal(12.w).copyWith(color: Styles.whiteText),
            ),
          ],
        ),
      ),
    );
  }

  Widget headBuilder(BuildContext ctx) {
    return Container(
      height: 0,
      color: Styles.normalBlue,
    );
  }

  Widget pinBuilder(BuildContext ctx) {
    return Container(
      height: 0,
      color: Styles.normalBlue,
    );
  }

  Widget bottomBuilder(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                onImagePickCallback: logic.pickAndSendImage,
                bgColor: Styles.navigationBarColor,
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget jumpBottomFloatBuilder(BuildContext context) {
    return const SizedBox();
  }

  Widget unreadTipFloatWidget() {
    return const SizedBox();
  }
}
