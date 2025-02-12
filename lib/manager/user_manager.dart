import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:relax_chat/helper/toast_helper.dart';
import 'package:relax_chat/manager/conversation_manager.dart';
import 'package:relax_chat/manager/database/dao/local_box_dao.dart';
import 'package:relax_chat/manager/socket/socket_manager.dart';
import 'package:relax_chat/pages/root/root_logic.dart';

import '../model/ws/req/ws_token_req.dart';
import '../route/routes.dart';
import 'event_bus_manager.dart';
import 'global_manager.dart';
import '../model/user_model.dart';
import '../network/api_manager.dart';
import '../network/net_request.dart';
import '../network/result.dart';

class UserManager {
  UserManager._() {
    loginSuccessSubscription =
        eventBus.on<WSLoginSuccessEvent>().listen((event) {
      ConversationManager.instance.refreshConversationList();
    });
  }

  static UserManager get instance => _instance ??= UserManager._();

  static UserManager? _instance;

  final UserState state = UserState();

  StreamSubscription? loginSuccessSubscription;

  Future<void> init() async {
    await _initUser();
  }

  Future<void> loadUserInfo() async {
    Result<UserModel> result = await api.getUserInfo();
    if (result.result) {
      state.user.value = result.data ?? UserModel.fromJson({});
      Get.find<RootLogic>().backToHome();
    } else {
      Get.find<RootLogic>().backToLogin();
    }
  }

  Future<void> _initUser() async {
    net.token = LocalBoxDao.instance.get('token') ?? '';
    if (net.token.isNotEmpty) {
      // 发送token直接登录
      WSTokenReq wsReq = WSTokenReq(3, TokenData(net.token));
      SocketManager.instance.send(jsonEncode(wsReq.toJson()));
    } else {
      showTipsToast('登录状态已失效～');
      Get.find<RootLogic>().backToLogin();
    }
  }
}

class UserState {
  Rx<UserModel> user = UserModel.fromJson({}).obs;

  bool get hasLogin => user.value.uid > 0;
}
