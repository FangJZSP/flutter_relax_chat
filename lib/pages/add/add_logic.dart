import 'package:get/get.dart';

import 'add_state.dart';

class AddLogic extends GetxController {
  final AddState state = AddState();

  void findPerson() {
    state.findType.value = FindType.person;
  }

  void findGroup() {
    state.findType.value = FindType.group;
  }
}
