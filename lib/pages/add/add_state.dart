import 'package:get/get.dart';

enum FindType {
  person,
  group,
  ;
}

class AddState {
  AddState() {
    ///Initialize variables
  }

  Rx<FindType> findType = FindType.person.obs;
}
