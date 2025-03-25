import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:relax_chat/common/size_config.dart';

import '../../common/common.dart';
import '../../helper/toast_helper.dart';
import '../../manager/global_manager.dart';
import '../../manager/user_manager.dart';
import '../../network/net_request.dart';
import '../../widgets/image/round_avatar.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final logic = Get.put(HomeLogic());
  final state = Get.find<HomeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Positioned.fill(
            child: Scaffold(
              key: state.scaleFoldKey,
              body: body(),
              drawer: drawer(),
              bottomNavigationBar: Obx(() => Theme(
                    data: Theme.of(context)
                        .copyWith(splashFactory: InkSplash.splashFactory),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          color: Styles.grey.withOpacity(0.1),
                          height: 1,
                          thickness: 1,
                        ),
                        BottomNavigationBar(
                          items: state.tabItems,
                          currentIndex: state.tabIndex.value,
                          type: BottomNavigationBarType.fixed,
                          backgroundColor:
                              Styles.navigationBarColor.withOpacity(0.9),
                          enableFeedback: true,
                          selectedLabelStyle: Styles.textNormal(10).copyWith(
                            color: Styles.normalBlue,
                          ),
                          unselectedLabelStyle: Styles.textNormal(10).copyWith(
                            color: Styles.blackText,
                          ),
                          onTap: (int index) {
                            logic.changeTabIndex(index);
                          },
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawer() {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.bodyPadding,
            right: SizeConfig.bodyPadding,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 44.w,
                child: Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        logic.closeDrawer();
                      },
                      child: Icon(
                        Icons.close,
                        size: 24.w,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: RoundAvatar(
                        height: 48.w,
                        url: UserManager.instance.state.user.value.avatar,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                UserManager.instance.state.user.value.name
                                        .isNotEmpty
                                    ? UserManager.instance.state.user.value.name
                                    : 'Loading...',
                                style: Styles.textNormal(16.w)
                                    .copyWith(color: Styles.blackText),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  logic.logout();
                                },
                                child: Text(
                                  '退出账号',
                                  style: Styles.textNormal(8.w)
                                      .copyWith(color: Styles.blackText),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'go relaxing',
                            style: Styles.textNormal(10.w)
                                .copyWith(color: Styles.greyText),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              Expanded(
                  child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '当前连接ws url:',
                      style: Styles.textNormal(16.w)
                          .copyWith(color: Styles.blackText),
                    ),
                    subtitle: Text(
                      GlobalManager.instance.state.isDev
                          ? Info.websocketDevUrl
                          : Info.websocketProdUrl,
                      style: Styles.textNormal(10.w)
                          .copyWith(color: Styles.normalBlue),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '当前用户token:',
                      style: Styles.textNormal(16.w)
                          .copyWith(color: Styles.blackText),
                    ),
                    subtitle: Text(
                      net.token,
                      style: Styles.textNormal(10.w)
                          .copyWith(color: Styles.normalBlue),
                    ),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: net.token));
                      showTipsToast('token复制成功：${net.token}');
                    },
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Obx(
      () => IndexedStack(
        index: state.tabIndex.value,
        key: key,
        children: state.pages,
      ),
    );
  }
}
