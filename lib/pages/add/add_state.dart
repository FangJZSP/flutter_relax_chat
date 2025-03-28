import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:relax_chat/model/room_model.dart';

enum FindType {
  person,
  group,
  ;
}

class AddState {
  Rx<FindType> findType = FindType.person.obs;

  TextEditingController txtController = TextEditingController();

  RxString inputStr = ''.obs;

  FocusNode focusNode = FocusNode();

  RxList<RoomModel> findGroups = RxList<RoomModel>.empty();

  AddState() {
    ///Initialize variables
  }
}
