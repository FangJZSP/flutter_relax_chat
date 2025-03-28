import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/common/size_config.dart';

import '../../common/common.dart';
import 'login_logic.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final logic = Get.put(LoginLogic());
  final state = Get.find<LoginLogic>().state;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Styles.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: mainContent(),
            ),
            Positioned(
              bottom: SizeConfig.bottomMargin + 20,
              right: 0,
              left: 0,
              child: loginOption(),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Relax',
          style: Styles.textBold(48).copyWith(color: Styles.deepBlue),
        ),
        const SizedBox(
          height: 200,
        ),
        GestureDetector(
          onTap: logic.goEmailLogin,
          child: Container(
            margin: const EdgeInsets.fromLTRB(70, 0, 70, 0),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: const BoxDecoration(
              color: Styles.deepBlue,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 16,
                  color: Styles.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  '登录',
                  style:
                      Styles.textNormal(14.w).copyWith(color: Styles.whiteText),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        userShouldKnow(),
      ],
    );
  }

  Widget backWidget() {
    return IconButton(
      onPressed: logic.back,
      icon: const Icon(
        Icons.arrow_back_ios,
        size: 28,
      ),
    );
  }

  Widget userShouldKnow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          WidgetSpan(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 3, right: 3),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Styles.grey),
              ),
            ),
          )),
          TextSpan(
              text: '已阅读并同意',
              style: Styles.textNormal(12).copyWith(color: Styles.greyText)),
          TextSpan(
              text: '服务协议',
              style: Styles.textNormal(12).copyWith(color: Styles.normalBlue)),
          TextSpan(
              text: '和',
              style: Styles.textNormal(12).copyWith(color: Styles.greyText)),
          TextSpan(
              text: 'RELAX隐私保护指引',
              style: Styles.textNormal(12).copyWith(color: Styles.normalBlue)),
        ]),
      ),
    );
  }

  Widget loginOption() {
    return const Icon(Icons.more_horiz_outlined);
  }
}
