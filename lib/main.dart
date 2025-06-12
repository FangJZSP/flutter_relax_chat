import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relax_chat/manager/database/base/keys.dart';
import 'package:relax_chat/manager/database/dao/local_box_dao.dart';
import 'package:relax_chat/network/api_manager.dart';
import 'app.dart';
import 'common/info.dart';
import 'manager/global_manager.dart';
import 'manager/socket/socket_manager.dart';
import 'manager/user_manager.dart';
import 'manager/database/dao_manager.dart';
import 'network/network_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.deferFirstFrame();
  // 设置状态栏样式
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 状态栏背景色设为透明
    statusBarIconBrightness: Brightness.dark, // 状态栏图标为黑色
    statusBarBrightness: Brightness.light, // iOS状态栏亮度
  ));
  launchApp();
}

Future<void> launchApp() async {
  /// 配置app环境
  GlobalManager.instance.isDev = true;

  /// 初始化缓存
  await DaoManager.instance.init();

  await NetworkHelper.instance.setupConfig(networkConfig);

  /// 初始化用户所需服务
  await UserManager.instance.init();

  /// 初始化WebSocket
  SocketManager.instance.init();

  runApp(const RelaxChatApp());
}

NetworkConfig get networkConfig {
  return NetworkConfig(
    apiKey: Info.ap,
    // useDevHost: GlobalManager.instance.isDev,
    useDevHost: false,
    host: ApiManager.hostStr,
    token: LocalBoxDao.instance.get(userTokenKey) ?? '',
    updateTokenCallback: (String token) {
      if (token.isNotEmpty) {
        LocalBoxDao.instance.set(userTokenKey, token);
      }
    },
    hasLogin: () => UserManager.instance.state.hasLogin,
    getCustomHeaders: () {
      // 自定义请求头
    },
    onResponseError: (uri, requestId, throwable) {
      // api错误上报
    },
  );
}
