import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:relax_chat/common/size_config.dart';
import 'package:relax_chat/helper/time_helper.dart';
import 'package:relax_chat/helper/toast_helper.dart';
import 'package:relax_chat/manager/socket/socket_manager.dart';
import 'package:relax_chat/manager/user_manager.dart';
import 'package:relax_chat/model/conversation_model.dart';
import 'package:relax_chat/widgets/image/round_avatar.dart';

import '../../common/common.dart';
import '../../manager/global_manager.dart';
import '../../network/net_request.dart';
import 'message_logic.dart';
import 'package:badges/badges.dart' as badges;

class MessagePage extends StatelessWidget {
  MessagePage({super.key});

  final logic = Get.put(MessageLogic());
  final state = Get.find<MessageLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(color: Styles.bgColor, child: mainContent());
  }

  Widget mainContent() {
    return Column(
      children: [
        appBar(),
        Expanded(
          child: GetBuilder<MessageLogic>(
            builder: (logic) {
              return Container(
                  margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
                  child: buildConversationList());
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: net.token));
            showTipsToast('token复制成功：${net.token}');
          },
          child: Text(
            '当前用户token: ${net.token}',
            style: Styles.textLight(10).copyWith(color: Styles.normalBlue),
          ),
        ),
        Text(
          '当前连接ws url: ${GlobalManager.instance.state.isDev ? Info.websocketDevUrl : Info.websocketProdUrl}',
          style: Styles.textLight(10).copyWith(color: Styles.normalBlue),
        ),
      ],
    );
  }

  Widget appBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, SizeConfig.topMargin, 16.w, 4.w),
      color: Styles.appBarColor.withOpacity(0.5),
      child: Row(
        children: [
          Obx(() {
            return RoundAvatar(
              height: 28.w,
              url: UserManager.instance.state.user.value.avatar,
            );
          }),
          SizedBox(width: 8.w),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UserManager.instance.state.user.value.name.isNotEmpty
                      ? UserManager.instance.state.user.value.name
                      : '无',
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
          Icon(
            Icons.add_sharp,
            size: 24.w,
          ),
        ],
      ),
    );
  }

  Widget buildConversationList() {
    return Obx(() => state.conversations.isNotEmpty
        ? ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 10.w, 0, 0),
            itemBuilder: (BuildContext context, int index) {
              return conversationCell(index);
            },
            itemCount: state.conversations.length,
          )
        : const Center(
            child: Text('还没有会话哦～'),
          ));
  }

  Widget conversationCell(int index, {bool showDivider = false}) {
    ConversationModel conversation = state.conversations[index];
    int roomUnreadMsg = (state.conversationUnreadList
            .firstWhereOrNull(
                (element) => element.roomId == conversation.roomId)
            ?.unreadMsgCount ??
        0);
    return GestureDetector(
      onTap: () {
        logic.goChat(conversation);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10.w, 0, 10.w),
        color: Styles.transparent,
        child: Row(
          children: [
            RoundAvatar(
              url: conversation.avatar,
              height: 40.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.name,
                        style: Styles.textNormal(16.w)
                            .copyWith(color: Styles.blackText),
                      ),
                      Text(
                        TimeUtils.timestamp3TimeString(conversation.activeTime),
                        style: Styles.textNormal(10.w)
                            .copyWith(color: Styles.greyText),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.text,
                        style: Styles.textNormal(12.w)
                            .copyWith(color: Styles.greyText),
                      ),
                      // 消息未读数
                      Visibility(
                        visible: roomUnreadMsg > 0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: badges.Badge(
                            badgeContent: Text(
                              roomUnreadMsg > 99
                                  ? '99+'
                                  : roomUnreadMsg.toString(),
                              style: Styles.textNormal(10)
                                  .copyWith(color: Styles.whiteText),
                            ),
                            child: Container(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget unreadWidget(int roomUnreadMsg) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 22, minWidth: 22),
      alignment: Alignment.center,
      decoration:
          const BoxDecoration(color: Styles.red, shape: BoxShape.circle),
      padding: const EdgeInsets.all(1),
      child: Text(
        roomUnreadMsg > 99 ? '99+' : roomUnreadMsg.toString(),
        style: Styles.textNormal(10).copyWith(color: Styles.whiteText),
      ),
    );
  }
}
