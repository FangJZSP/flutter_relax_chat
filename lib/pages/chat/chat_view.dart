import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/common/size_config.dart';
import 'package:relax_chat/widgets/base/base_app_bar.dart';

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
    });
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
              style: Styles.textNormal(12.w).copyWith(color: Styles.whiteText),
            ),
          ],
        ),
      ),
    );
  }

  Widget headBuilder(BuildContext ctx) {
    return BaseAppBar(
      needTopMargin: false,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
          Container(),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.conversation.value.name.isNotEmpty
                      ? state.conversation.value.name
                      : 'Loading',
                  style:
                      Styles.textNormal(14.w).copyWith(color: Styles.blackText),
                ),
                Obx(() {
                  return Text(
                    SocketManager.instance.didConnect.value ? '在线>' : '离线>',
                    style: Styles.textNormal(8.w)
                        .copyWith(color: Styles.blackText),
                  );
                }),
              ],
            );
          }),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.dehaze),
            onPressed: () {},
          ),
        ],
      ),
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
