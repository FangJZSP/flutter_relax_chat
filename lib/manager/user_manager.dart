import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:relax_chat/helper/toast_helper.dart';
import 'package:relax_chat/manager/conversation_manager.dart';
import 'package:relax_chat/manager/socket/socket_manager.dart';
import 'package:relax_chat/pages/root/root_logic.dart';

import '../model/ws/req/ws_token_req.dart';
import '../pages/home/home_logic.dart';
import '../route/routes.dart';
import 'database/dao/local_box_dao.dart';
import 'event_bus_manager.dart';
import 'contact_manager.dart';
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
      ContactManager.instance.refreshFriendList();
      ContactManager.instance.refreshGroupRoomList();
    });
  }

  static UserManager get instance => _instance ??= UserManager._();

  static UserManager? _instance;

  final UserState state = UserState();

  StreamSubscription? loginSuccessSubscription;

  Future<void> init() async {
    await initUser();
  }

  /// 初始化用户
  Future<void> initUser() async {
    net.token = LocalBoxDao.instance.get('token') ?? '';
    if (net.token.isNotEmpty) {
      // 发送token直接登录
      WSTokenReq wsReq = WSTokenReq(3, TokenData(net.token));
      SocketManager.instance.send(jsonEncode(wsReq.toJson()));
    } else {
      GlobalManager.instance.state.firstRoute = Routes.login;
    }
  }

  /// 登录成功后重新拉取用户
  Future<void> loadUser() async {
    Result<UserModel> result = await api.getUserInfo();
    if (result.ok) {
      state.user.value = result.data ?? UserModel.fromJson({});
    }
  }

  Future<void> logOut() async {
    showTipsToast('你已登出～');
    LocalBoxDao.instance.set('token', '');
    /// 手动删除HomeLogic
    Get.delete<HomeLogic>();
    Get.find<RootLogic>().backToLogin();
  }
}

class UserState {
  Rx<UserModel> user = UserModel.fromJson({}).obs;

  bool get hasLogin => user.value.uid > 0;
}
