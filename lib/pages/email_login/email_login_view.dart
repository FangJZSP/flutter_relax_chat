import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/common/common.dart';

import '../../../common/styles.dart';
import 'email_login_logic.dart';

class EmailLoginPage extends StatelessWidget {
  EmailLoginPage({super.key});

  final logic = Get.put(EmailLoginLogic());
  final state = Get.find<EmailLoginLogic>().state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: logic.onTabBg,
      child: Scaffold(
        backgroundColor: Styles.white,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: mainContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainContent() {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                backWidget(),
              ],
            ),
          ),
          Text(
            state.showRegisterView.value ? '邮箱注册' : '邮箱登录',
            style: Styles.textNormal(24).copyWith(color: Styles.blackText),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            '需要登录后，才能聊天哦～',
            style: Styles.textNormal(12).copyWith(color: Styles.greyText),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 40, 50, 0),
            child: Column(
              children: [
                if (state.showRegisterView.value)
                  TextField(
                    controller: state.nameTextEditingController,
                    focusNode: state.nameFocusNode,
                    maxLength: 20,
                    decoration: const InputDecoration(hintText: '昵称～'),
                    onChanged: (txt) {
                      logic.checkCanSubmit();
                    },
                  ),
                TextField(
                  controller: state.emailTextEditingController,
                  focusNode: state.emailFocusNode,
                  maxLength: 20,
                  decoration: const InputDecoration(hintText: '请输入邮箱～'),
                  onChanged: (txt) {
                    logic.checkCanSubmit();
                  },
                ),
                TextField(
                  controller: state.passwordTextEditingController,
                  focusNode: state.passwordFocusNode,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    hintText: '请输入密码～',
                  ),
                  onChanged: (txt) {
                    logic.checkCanSubmit();
                  },
                  // 该属性会导致点击输入框，仍然失去焦点
                  obscureText: true,
                ),
                if (state.showRegisterView.value)
                  TextField(
                    controller: state.codeTextEditingController,
                    focusNode: state.codeFocusNode,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      hintText: '验证码～',
                    ),
                    onChanged: (txt) {
                      logic.checkCanSubmit();
                    },
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: logic.changeMethod,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.swap_horiz,
                            size: 12,
                            color: Styles.black,
                          ),
                          Text(
                            state.showRegisterView.value ? '密码登录' : '邮箱注册',
                            style: Styles.textNormal(12)
                                .copyWith(color: Styles.blackText),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: state.showRegisterView.value
                          ? logic.getVerifyCode
                          : logic.forgetPassword,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      child: Text(
                        state.showRegisterView.value ? '获取邮箱验证码～' : '忘记密码？',
                        style: Styles.textNormal(12)
                            .copyWith(color: Styles.blackText),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: state.showRegisterView.value
                      ? logic.register
                      : logic.login,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: state.canSubmit.value
                            ? Styles.confirmedBtnColor
                            : Styles.unconfirmedBtnColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.showRegisterView.value ? '验证并登录' : '登录',
                          style: Styles.textNormal(16.w)
                              .copyWith(color: Styles.whiteText),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          userShouldKnow(),
        ],
      );
    });
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
}
