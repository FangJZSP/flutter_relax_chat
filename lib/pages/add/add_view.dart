import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/model/room_model.dart';
import 'package:relax_chat/pages/add/add_state.dart';
import 'package:relax_chat/widgets/base/base_app_bar.dart';
import 'package:relax_chat/widgets/image/round_avatar.dart';

import '../../common/common.dart';
import '../../model/user_model.dart';
import '../../widgets/custom_text_field.dart';
import 'add_logic.dart';

class AddPage extends StatelessWidget {
  AddPage({super.key});

  final logic = Get.put(AddLogic());
  final state = Get.find<AddLogic>().state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: logic.onTapBg,
      child: Scaffold(
        backgroundColor: Styles.white,
        body: Column(
          children: [
            BaseAppBar(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  selectSegment(),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
            findInputBar(),
            Expanded(
                child: Container(
              color: Styles.greyBgColor,
              child: Obx(() {
                return state.findType.value == FindType.group
                    ? groupListView()
                    : personListView();
              }),
            )),
          ],
        ),
      ),
    );
  }

  Widget selectSegment() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: logic.findPerson,
            child: Container(
              decoration: BoxDecoration(
                border: const Border(
                  top: BorderSide(color: Styles.black),
                  left: BorderSide(color: Styles.black),
                  bottom: BorderSide(color: Styles.black),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2.w),
                  bottomLeft: Radius.circular(2.w),
                ),
                color: state.findType.value == FindType.person
                    ? Styles.black
                    : Styles.white,
              ),
              padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
              child: Text(
                '找人',
                style: Styles.textNormal(12.w).copyWith(
                    color: state.findType.value == FindType.person
                        ? Styles.white
                        : Styles.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: logic.findGroup,
            child: Container(
              decoration: BoxDecoration(
                border: const Border(
                  top: BorderSide(color: Styles.black),
                  right: BorderSide(color: Styles.black),
                  bottom: BorderSide(color: Styles.black),
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(2.w),
                  bottomRight: Radius.circular(2.w),
                ),
                color: state.findType.value == FindType.group
                    ? Styles.black
                    : Styles.white,
              ),
              padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
              child: Text('找群',
                  style: Styles.textNormal(12.w).copyWith(
                      color: state.findType.value == FindType.group
                          ? Styles.white
                          : Styles.black)),
            ),
          ),
        ],
      );
    });
  }

  Widget findInputBar() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: state.txtController,
                focusNode: state.focusNode,
                maxLine: 1,
                onChanged: (value) {
                  state.inputStr.value = value;
                },
                hintText: state.findType.value == FindType.person
                    ? '🔍用户名~'
                    : '🔍群名~',
                boxField: true,
                contentPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
                hintTextStyle:
                    Styles.textNormal(12.w).copyWith(color: Styles.greyText),
                inputTextStyle:
                    Styles.textNormal(12.w).copyWith(color: Styles.blackText),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: logic.searchFind,
              child: Container(
                padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
                decoration: BoxDecoration(
                  color: Styles.normalBlue,
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Text(
                  '搜索',
                  style: Styles.textNormal(12.w).copyWith(
                    color: Styles.whiteText,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget groupCell(RoomModel room) {
    return Padding(
      padding: EdgeInsets.all(8.0.w),
      child: Row(
        children: [
          RoundAvatar(
            height: 48.w,
            url: room.avatar,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: Styles.textLight(16.w).copyWith(
                    color: Styles.blackText,
                  ),
                ),
                SizedBox(height: 4.w),
                Row(
                  children: [
                    tag(
                      Icon(
                        Icons.person_outline,
                        size: 12.w,
                        color: Styles.grey,
                      ),
                      Text(
                        room.memberCount.toString(),
                        style: Styles.textLight(12.w).copyWith(
                          color: Styles.greyText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: room.isJoined ? null : logic.addFind,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(color: Styles.black)),
              child: Text(
                room.isJoined ? '已加入' : '加入',
                style: Styles.textNormal(12.w).copyWith(
                  color: Styles.blackText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget personCell(UserModel user) {
    return Padding(
      padding: EdgeInsets.all(8.0.w),
      child: Row(
        children: [
          RoundAvatar(
            height: 48.w,
            url: user.avatar,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Styles.textLight(16.w).copyWith(
                    color: Styles.blackText,
                  ),
                ),
                SizedBox(height: 4.w),
                Row(
                  children: [
                    tag(
                      Icon(
                        user.sex == 0 ? Icons.male : Icons.female,
                        size: 14.w,
                        color: Styles.grey,
                      ),
                      Text(
                        user.sex == 0 ? '男' : '女',
                        style: Styles.textLight(10.w).copyWith(
                          color: Styles.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: user.isFriend ? null : logic.addFind,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(color: Styles.black)),
              child: Text(
                user.isFriend ? '已添加' : '加好友',
                style: Styles.textNormal(12.w).copyWith(
                  color: Styles.blackText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tag(Icon icon, Widget child) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
      decoration: BoxDecoration(
        color: Styles.greyBgColor,
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          child,
        ],
      ),
    );
  }

  Widget groupListView() {
    return Container(
      margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0),
      decoration: BoxDecoration(
        color: Styles.white,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Obx(() {
        return state.findPeople.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.bottomMargin),
                  child: Text(
                    '点击搜索，寻找更多群聊～',
                    style: Styles.textNormal(16.w)
                        .copyWith(color: Styles.greyText),
                  ),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: state.findGroups.length,
                itemBuilder: (BuildContext context, int index) {
                  return groupCell(state.findGroups[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              );
      }),
    );
  }

  Widget personListView() {
    return Container(
      margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0),
      decoration: BoxDecoration(
        color: Styles.white,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Obx(() {
        return state.findPeople.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.bottomMargin),
                  child: Text(
                    '点击搜索，寻找更多好友～',
                    style: Styles.textNormal(16.w)
                        .copyWith(color: Styles.greyText),
                  ),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: state.findPeople.length,
                itemBuilder: (BuildContext context, int index) {
                  return personCell(state.findPeople[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              );
      }),
    );
  }
}
