import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common.dart';
import '../../manager/user_manager.dart';
import '../../model/resp/friend_list_resp.dart';
import '../../model/room_model.dart';
import '../../model/widget/contact_type_model.dart';
import '../../widgets/base/base_app_bar.dart';
import '../../widgets/image/round_avatar.dart';
import 'contact_logic.dart';
import 'contact_state.dart';

class ContactPage extends StatelessWidget {
  ContactPage({super.key});

  final logic = Get.put(ContactLogic());
  final state = Get.find<ContactLogic>().state;

  @override
  Widget build(BuildContext context) {
    state.context = context;
    return Container(color: Styles.bgColor, child: mainContent());
  }

  Widget mainContent() {
    return Column(
      children: [
        appBar(),
        buildSearchBar(),
        buildNewFriendNotice(),
        buildGroupNotice(),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 12.w),
          child: Divider(
            height: 1,
            color: Styles.grey.withOpacity(.2),
          ),
        ),
        typeBar(),
        Expanded(
          child: _buildPageView(),
        ),
      ],
    );
  }

  Widget appBar() {
    return BaseAppBar(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
        child: Row(
          children: [
            Obx(() {
              return GestureDetector(
                onTap: logic.openDrawer,
                child: RoundAvatar(
                  height: 28.w,
                  url: UserManager.instance.state.user.value.avatar,
                ),
              );
            }),
            SizedBox(width: 8.w),
            Text(
              '联系人',
              style: Styles.textFiraNormal(18.w).copyWith(color: Styles.blackText),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                logic.goAdd();
              },
              icon: Icon(
                Icons.person_add_alt,
                size: 24.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 搜索栏
  Widget buildSearchBar() {
    return Container(
      color: Styles.white,
      child: GestureDetector(
        onTap: logic.goAdd,
        child: Container(
          height: 32,
          margin: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Styles.greyBgColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 16.w,
                color: Styles.greyText,
              ),
              Text(
                '搜索',
                style: Styles.textFiraNormal(14.w).copyWith(color: Styles.greyText),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNewFriendNotice() {
    return GestureDetector(
      onTap: logic.goNewFriend,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 8.w),
        child: Row(
          children: [
            Expanded(
                child: Text(
              '新朋友',
              style: Styles.textFiraNormal(16.w).copyWith(color: Styles.blackText),
            )),
            Icon(
              Icons.arrow_forward_ios,
              size: 12.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGroupNotice() {
    return GestureDetector(
      onTap: logic.goGroupNotice,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 0),
        child: Row(
          children: [
            Expanded(
                child: Text(
              '群通知',
              style: Styles.textFiraNormal(16.w).copyWith(color: Styles.blackText),
            )),
            Icon(
              Icons.arrow_forward_ios,
              size: 12.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget typeBar() {
    return Container(
      height: 30.w,
      margin: EdgeInsets.only(bottom: 10.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: state.contacts.length,
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
        itemBuilder: (BuildContext context, int index) {
          return _typeCell(index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 12.w,
          );
        },
      ),
    );
  }

  Widget _typeCell(int index) {
    ContactData model = state.contacts[index];
    return Obx(() {
      return GestureDetector(
        onTap: () {
          logic.onSelectType(index);
        },
        child: Container(
            alignment: Alignment.center,
            color: Styles.transparent,
            child: Column(
              children: [
                Text(
                  model.contactType.desc,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: Styles.textFiraNormal(14.w).copyWith(
                    height: 0.85,
                    color: state.selectedType.value == index
                        ? Styles.normalBlue
                        : Styles.blackText,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.w),
                Container(
                  height: 2,
                  width: 26.w,
                  color: state.selectedType.value == index
                      ? Styles.normalBlue
                      : Styles.transparent,
                ),
              ],
            )),
      );
    });
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: state.pageController,
      itemCount: state.contacts.length,
      scrollDirection: Axis.horizontal,
      onPageChanged: logic.onPageChanged,
      itemBuilder: (context, index) {
        ContactData data = state.contacts[index];
        return EasyRefresh.builder(
          controller: data.refreshController,
          onRefresh: () {
            if (data.contactType.desc == ContactType.friend.desc) {
              logic.refreshFriendList();
            }
            if (data.contactType.desc == ContactType.groupChat.desc) {
              logic.refreshGroupRoomList();
            }
          },
          childBuilder: (context, physics) {
            return Obx(() {
              return typeListView(data, physics);
            });
          },
        );
      },
    );
  }

  // 联系人列表
  Widget typeListView(ContactData data, ScrollPhysics physics) {
    return ListView.separated(
      physics: physics,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
      itemCount: data.dataList.length,
      itemBuilder: (context, index) {
        var item = data.dataList[index];
        if (item is FriendModel) {
          return friendCell(item);
        }
        if (item is RoomModel) {
          return groupCell(item);
        }
        return const SizedBox();
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 16.w);
      },
    );
  }

  Widget friendCell(FriendModel friend) {
    return GestureDetector(
      onTap: () {
        logic.goProfile(friend);
      },
      child: Container(
        color: Styles.transparent,
        child: Row(
          children: [
            RoundAvatar(
              height: 42.w,
              url: friend.avatar,
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  friend.name,
                  style:
                      Styles.textFiraNormal(16.w).copyWith(color: Styles.blackText),
                ),
                SizedBox(height: 4.w),
                Text(
                  '[设备在线～] go relaxing',
                  style:
                      Styles.textFiraNormal(10.w).copyWith(color: Styles.greyText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget groupCell(RoomModel room) {
    return GestureDetector(
      onTap: () {
        logic.goChat(room);
      },
      child: Container(
        color: Styles.transparent,
        child: Row(
          children: [
            RoundAvatar(
              height: 42.w,
              url: room.avatar,
            ),
            SizedBox(width: 8.w),
            Text(
              room.name,
              style: Styles.textFiraNormal(16.w).copyWith(color: Styles.blackText),
            ),
          ],
        ),
      ),
    );
  }
}
