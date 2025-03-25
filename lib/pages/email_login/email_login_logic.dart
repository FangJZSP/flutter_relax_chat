import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:relax_chat/helper/toast_helper.dart';
import 'package:get/get.dart';
import 'package:relax_chat/manager/log_manager.dart';
import 'package:relax_chat/manager/socket/socket_manager.dart';
import 'package:relax_chat/network/api_manager.dart';
import '../../../model/ws/req/ws_email_req.dart';
import '../../../network/result.dart';
import 'email_login_state.dart';

class EmailLoginLogic extends GetxController {
  final EmailLoginState state = EmailLoginState();

  @override
  void onClose() {
    state.nameTextEditingController.dispose();
    state.codeTextEditingController.dispose();
    state.emailTextEditingController.dispose();
    state.passwordTextEditingController.dispose();
    state.nameFocusNode.dispose();
    state.emailFocusNode.dispose();
    state.codeFocusNode.dispose();
    state.passwordFocusNode.dispose();
    super.onClose();
  }

  void back() {
    Get.back();
  }

  void onTabBg() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void changeMethod() {
    onTabBg();
    state.showRegisterView.value = !state.showRegisterView.value;
  }

  void forgetPassword() {}

  /// 检验是否可以提交
  void checkCanSubmit() {
    if (state.showRegisterView.value) {
      if (state.nameTextEditingController.text.isNotEmpty &&
          state.emailTextEditingController.text.isNotEmpty &&
          state.passwordTextEditingController.text.isNotEmpty &&
          state.codeTextEditingController.text.isNotEmpty) {
        state.canSubmit.value = true;
        return;
      }
    } else {
      if (state.emailTextEditingController.text.isNotEmpty &&
          state.passwordTextEditingController.text.isNotEmpty) {
        state.canSubmit.value = true;
        return;
      }
    }
    state.canSubmit.value = false;
  }

  void getVerifyCode() {
    String email = state.emailTextEditingController.text;
    if (email.isEmpty || !email.contains('@')) {
      showTipsToast('邮箱是不是有问题咧');
      return;
    }
    // 发送email信息，并根据邮箱发送验证码
    WSEmailReq wsReq = WSEmailReq(4, EmailData(email, true));
    SocketManager.instance.send(jsonEncode(wsReq.toJson()));
  }

  Future<void> register() async {
    if (!state.canSubmit.value) {
      showTipsToast('是不是有信息没有填呀~');
      return;
    }
    showLoadingToast();
    String email = state.emailTextEditingController.text;
    String password = state.passwordTextEditingController.text;
    String code = state.codeTextEditingController.text;
    String name = state.nameTextEditingController.text;
    Result result = await api.userRegister(
      email: email,
      password: password,
      code: code,
      name: name,
    );
    cleanAllToast();
    if (result.ok) {
      showTipsToast('用户登录成功');
    } else {
      showTipsToast('用户或者密码错误');
    }
  }

  Future<void> login() async {
    if (!state.canSubmit.value) {
      logger.d('邮箱或密码不能为空');
      showTipsToast('邮箱或密码不能为空');
      return;
    }
    showLoadingToast();
    String email = state.emailTextEditingController.text;
    String password = state.passwordTextEditingController.text;
    // 发送email信息，根据email将未绑定channel的用户绑定固定的channel
    WSEmailReq wsReq = WSEmailReq(4, EmailData(email, false));
    SocketManager.instance.send(jsonEncode(wsReq.toJson()));
    Result result = await api.userLogin(
      email: email,
      password: password,
    );
    cleanAllToast();
    if (result.ok) {
      showTipsToast('用户登录成功');
    } else {
      showTipsToast('用户或者密码错误');
    }
  }
}
