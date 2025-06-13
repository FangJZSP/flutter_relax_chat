import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relax_chat/pages/message/message_view.dart';
import '../../common/common.dart';
import '../contact/contact_view.dart';

enum HomeSubPage {
  messagePage(1),
  contactPage(2),
  ;

  final int tab;

  const HomeSubPage(this.tab);
}

class HomeState {
  RxInt tabIndex = 0.obs;
  RxInt lastTabIndex = 0.obs;

  StreamSubscription? backToRouteEventBus;

  GlobalKey<ScaffoldState> scaleFoldKey = GlobalKey();

  final List<Widget> pages = <Widget>[
    MessagePage(),
    ContactPage(),
  ];

  int get tabCount => pages.length;

  // 选择图片
  final ImagePicker picker = ImagePicker();

  HomeState() {
    ///Initialize variables
  }

  List<BottomNavigationBarItem> get tabItems {
    List<BottomNavigationBarItem> list = [
      const BottomNavigationBarItem(
        label: '消息',
        icon: Icon(
          Icons.messenger_outline,
          color: Styles.black,
        ),
        activeIcon: Icon(
          Icons.messenger_outline,
          color: Styles.normalBlue,
        ),
      ),
      const BottomNavigationBarItem(
        label: '联系人',
        icon: Icon(
          Icons.person_outlined,
          color: Styles.black,
        ),
        activeIcon: Icon(
          Icons.person_outlined,
          color: Styles.normalBlue,
        ),
      ),
    ];
    return list;
  }
}
