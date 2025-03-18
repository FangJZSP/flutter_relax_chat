import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/common.dart';
import '../../helper/toast_helper.dart';
import '../../manager/global_manager.dart';
import '../../network/net_request.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final logic = Get.put(HomeLogic());
  final state = Get.find<HomeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
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
        child: Column(
          children: [
            GestureDetector(
                onTap: () {
                  logic.closeDrawer();
                },
                child: Text('nihao')),
            const Spacer(),
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
        ),
      ),
    );
  }

  Widget body() {
    return Obx(() {
      return PageTransitionSwitcher(
        reverse: state.tabIndex.value < state.lastTabIndex.value,
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            fillColor: Styles.transparent,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: state.pages[state.tabIndex.value],
      );
    });
  }
}
