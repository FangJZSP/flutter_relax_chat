import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/model/room_model.dart';
import 'package:relax_chat/model/widget/contact_type_model.dart';
import '../../model/resp/friend_list_resp.dart';
import '../../manager/contact_manager.dart';

class ContactState {
  late BuildContext context;

  RxList<FriendModel> get friends => ContactManager.instance.state.friends;

  RxList<RoomModel> get groupRooms => ContactManager.instance.state.groupRooms;

  List<ContactData> contacts = [];

  RxInt selectedType = 0.obs;

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
