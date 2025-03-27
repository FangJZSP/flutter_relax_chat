import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:relax_chat/helper/toast_helper.dart';
import 'package:relax_chat/manager/conversation_manager.dart';
import 'package:relax_chat/manager/database/base/keys.dart';
import 'package:relax_chat/manager/database/dao/user_box_dao.dart';
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
    await initLocalUser();
    await initForLaunch();
  }

  /// 启动app时初始化用户
  Future<void> initLocalUser() async {
    net.token = LocalBoxDao.instance.get(userTokenKey) ?? '';
    String userStr = LocalBoxDao.instance.get(userInfoKey) ?? '';
    if (userStr.isNotEmpty && net.token.isNotEmpty) {
      UserModel user = UserModel.fromJson(json.decode(userStr) ?? {});
      _resetUser(user);
    }
  }

  /// 初始化用户
  Future<void> initForLaunch() async {
    net.token = LocalBoxDao.instance.get(userTokenKey) ?? '';
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
      UserBoxDao.instance.update(state.user.value);
      updateLocalUserInfo(state.user.value, newUser: true);
    }
  }

  bool updateLocalUserInfo(UserModel user, {bool? newUser}) {
    if (newUser == true || (user.uid == state.user.value.uid)) {
      String value = json.encode(user.toJson());
      LocalBoxDao.instance.set(userInfoKey, value);
      return true;
    } else {
      return false;
    }
  }

  void _resetUser(UserModel? user) {
    if (user != null) {
      state.user.value = user;
    }
  }

  Future<void> logOut() async {
    showTipsToast('你已登出～');
    LocalBoxDao.instance.set(userTokenKey, '');

    /// 手动删除HomeLogic
    Get.delete<HomeLogic>();
    Get.find<RootLogic>().backToLogin();
  }
}

class UserState {
  Rx<UserModel> user = UserModel.fromJson({}).obs;

  bool get hasLogin => user.value.uid > 0;
}
