import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/model/resp/friend_list_resp.dart';
import 'package:relax_chat/model/user_model.dart';
import 'package:relax_chat/widgets/base/base_app_bar.dart';
import 'package:relax_chat/widgets/image/round_avatar.dart';

import '../../common/common.dart';
import 'new_friend_logic.dart';

class NewFriendPage extends StatelessWidget {
  NewFriendPage({super.key});

  final logic = Get.put(NewFriendLogic());
  final state = Get.find<NewFriendLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.white,
      body: Column(
        children: [
          BaseAppBar(
            appBarColor: Styles.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '新朋友',
                      style: Styles.textNormal(18.w),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Positioned(
                  right: 16.w,
                  child: GestureDetector(
                    onTap: logic.goAdd,
                    child: Text(
                      '添加',
                      style: Styles.textNormal(16.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '好友通知',
                      style: Styles.textBold(12.w),
                    ),
                  ],
                ),
                Expanded(child: newFriendApplyList()),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget newFriendApplyList() {
    return EasyRefresh.builder(
      controller: state.refreshController,
      onRefresh: () => logic.refreshNewFriendList(isRefresh: true),
      onLoad: () => logic.refreshNewFriendList(isRefresh: false),
      childBuilder: (context, physics) {
        return Obx(() {
          return ListView.builder(
            padding: EdgeInsets.zero,
            physics: physics,
            itemCount: state.applyList.length,
            itemBuilder: (context, index) {
              return newFriendCell(state.applyList[index]);
            },
          );
        });
      },
    );
  }

  Widget newFriendCell(FriendModel friend) {
    return Row(
      children: [
        RoundAvatar(
          height: 48.w,
          url: friend.avatar,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              friend.name,
            ),
          ],
        )),
      ],
    );
  }
}
