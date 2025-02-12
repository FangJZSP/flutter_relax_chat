import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/common.dart';
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
              body: body(),
              bottomNavigationBar: Obx(() => Theme(
                    data: Theme.of(context)
                        .copyWith(splashFactory: InkSplash.splashFactory),
                    child: BottomNavigationBar(
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
                        color: Styles.black,
                      ),
                      onTap: (int index) {
                        logic.changeTabIndex(index);
                      },
                    ),
                  )),
            ),
          ),
        ],
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
