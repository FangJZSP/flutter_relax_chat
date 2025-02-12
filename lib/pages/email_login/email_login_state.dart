import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailLoginState {
  RxBool showRegisterView = false.obs;
  RxBool canSubmit = false.obs;

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController codeTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode codeFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  EmailLoginState() {
    ///Initialize variables
  }
}
