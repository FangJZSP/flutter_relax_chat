import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/pages/root/root_logic.dart';

import '../root/root_view.dart';
import 'contact_logic.dart';

class ContactPage extends StatelessWidget {
  ContactPage({Key? key}) : super(key: key);

  final logic = Get.put(ContactLogic());
  final state = Get.find<ContactLogic>().state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<RootLogic>().backToLogin();
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          '登录',
        ),
      ),
    );
  }
}
