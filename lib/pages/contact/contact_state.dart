import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/model/room_model.dart';
import 'package:relax_chat/model/widget/contact_type_model.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../common/common.dart';
import '../../model/resp/friend_list_resp.dart';
import '../../manager/contact_manager.dart';

class ContactState {
  RxList<FriendModel> get friends => ContactManager.instance.state.friends;

  RxList<RoomModel> get groupRooms => ContactManager.instance.state.groupRooms;

  List<ContactData> contacts = [];

  RxInt selectedType = 0.obs;

  AutoScrollController scrollController = AutoScrollController(
    viewportBoundaryGetter: () =>
        Rect.fromLTRB(20, 0, 0, SizeConfig.bottomMargin),
    axis: Axis.horizontal,
  );

  PageController pageController = PageController(keepPage: true);

  ContactState();
}

class ContactData<T> {
  ContactTypeModel contactType;
  RxList<T> dataList;

  int currentPage = 1;
  RxBool firstTimeLoad = true.obs;
  EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
  );

  ContactData({
    required this.contactType,
    required this.dataList,
  });
}
