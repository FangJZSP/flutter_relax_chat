import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minio_flutter/minio.dart';
import 'app.dart';
import 'manager/global_manager.dart';
import 'manager/socket/socket_manager.dart';
import 'manager/user_manager.dart';
import 'manager/database/dao_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.deferFirstFrame();
  // 设置状态栏样式
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 状态栏背景色设为透明
    statusBarIconBrightness: Brightness.dark, // 状态栏图标为黑色
    statusBarBrightness: Brightness.light, // iOS状态栏亮度
  ));
  Minio.init(
    endPoint: '8.153.38.39',
    port: 9000,
    accessKey: 'RhJkFRrfHpttD3n9',
    secretKey: 'tWI2fPuEY64wBuqgQnV7kVVKfocSSHyZ',
    useSSL: false,
  );
  launchApp();
}

Future<void> launchApp() async {
  /// 配置app环境
  GlobalManager.instance.isDev = true;

  /// 初始化缓存
  await DaoManager.instance.init();

  /// 初始化用户所需服务
  await UserManager.instance.init();

  /// 初始化WebSocket
  SocketManager.instance.init();

  runApp(const RelaxChatApp());
}
