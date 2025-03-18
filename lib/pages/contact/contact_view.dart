import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../common/common.dart';
import '../../manager/user_manager.dart';
import '../../model/resp/friend_list_resp.dart';
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
    return Container(color: Styles.bgColor, child: mainContent());
  }

  Widget mainContent() {
    return Column(
      children: [
        appBar(),
        _buildSearchBar(),
        _typeBar(),
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
              return RoundAvatar(
                height: 28.w,
                url: UserManager.instance.state.user.value.avatar,
              );
            }),
            SizedBox(width: 8.w),
            Text(
              '联系人',
              style: Styles.textNormal(18.w).copyWith(color: Styles.blackText),
            ),
            const Spacer(),
            Icon(
              Icons.person_add_alt,
              size: 24.w,
            ),
          ],
        ),
      ),
    );
  }

  // 搜索栏
  Widget _buildSearchBar() {
    return Container(
      color: Styles.white,
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
              style: Styles.textNormal(14.w).copyWith(color: Styles.greyText),
            )
          ],
        ),
      ),
    );
  }

  Widget _typeBar() {
    return Visibility(
      visible: state.contacts.isNotEmpty,
      child: Container(
        height: 30.w,
        margin: EdgeInsets.only(bottom: 10.w),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: state.contacts.length,
          controller: state.scrollController,
          itemBuilder: (BuildContext context, int index) {
            return AutoScrollTag(
                key: ValueKey(index),
                controller: state.scrollController,
                index: index,
                child: _typeCell(index));
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 12.w,
            );
          },
        ),
      ),
    );
  }

  Widget _typeCell(int index) {
    double marginStartWidth = 0;
    double marginEndWidth = 0;
    if (index == 0) {
      //开头
      marginStartWidth = 20.pt;
    } else if (index == state.contacts.length - 1) {
      //末尾
      marginEndWidth = 20.pt;
    }
    if (index >= state.contacts.length) {
      return Container();
    }
    ContactData model = state.contacts[index];
    return Obx(() {
      return GestureDetector(
        onTap: () {
          logic.onSelectType(index);
        },
        child: Container(
            margin:
                EdgeInsets.only(left: marginStartWidth, right: marginEndWidth),
            alignment: Alignment.center,
            color: Styles.transparent,
            child: Column(
              children: [
                Text(
                  model.contactType.name,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: Styles.textNormal(14.w).copyWith(
                    height: 0.85,
                    color: state.selectedType.value == index
                        ? Styles.normalBlue
                        : Styles.greyText,
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
      itemBuilder: (context, index) {
        ContactData data = state.contacts[index];
        return EasyRefresh.builder(
            controller: data.refreshController,
            onRefresh: () {
              logic.refreshFriendList();
            },
            onLoad: () {
              logic.refreshFriendList(isRefresh: false);
            },
            childBuilder: (context, physics) {
              return Obx(
                () => typeListView(data, physics),
              );
            });
      },
      controller: state.pageController,
      itemCount: state.contacts.length,
      scrollDirection: Axis.horizontal,
      onPageChanged: logic.onScrollToPage,
    );
  }

  // 好友列表
  Widget typeListView(ContactData data, ScrollPhysics physics) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
      itemCount: state.friends.length,
      itemBuilder: (context, index) {
        return friendCell(state.friends[index]);
      },
    );
  }

  Widget friendCell(FriendModel friend) {
    return GestureDetector(
      onTap: () {
        logic.goChat(friend);
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
                      Styles.textNormal(16.w).copyWith(color: Styles.blackText),
                ),
                SizedBox(height: 4.w),
                Text(
                  '[设备在线～] go relaxing',
                  style:
                      Styles.textNormal(10.w).copyWith(color: Styles.greyText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
