import 'package:flutter/material.dart';
import 'package:relax_chat/pages/root/root_view.dart';
import 'app.dart';
import 'manager/conversation_manager.dart';
import 'manager/global_manager.dart';
import 'manager/socket/socket_manager.dart';
import 'manager/user_manager.dart';
import 'manager/database/dao_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  launchApp();
}

Future<void> launchApp() async {
  /// 配置app环境
  GlobalManager.instance.state.isDev = false;

  /// 初始化缓存
  await DaoManager.instance.init();

  /// 初始化WebSocket
  SocketManager.instance.init();

  /// 初始化用户所需服务
  await UserManager.instance.init();

  runApp(const RelaxChatApp());
}
