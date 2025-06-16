import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minio_flutter/minio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'app.dart';
import 'common/common.dart';
import 'manager/global_manager.dart';
import 'manager/log_manager.dart';
import 'manager/socket/socket_manager.dart';
import 'manager/user_manager.dart';
import 'manager/database/dao_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.deferFirstFrame();
  // 设置状态栏样式
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 状态栏背景色设为透明
    statusBarIconBrightness: Brightness.dark, // 状态栏图标为黑色
    statusBarBrightness: Brightness.light, // iOS状态栏亮度
  ));
  Minio.init(
    endPoint: Info.minioEndPoint,
    port: Info.minioPort,
    accessKey: Info.minioAccessKey,
    secretKey: Info.minioSecretKey,
    useSSL: Info.minioUseSSL,
  );
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://bd62f5e1ec49e2671154d28d0c795b00@o4509506232385536.ingest.us.sentry.io/4509506233499648';
      options.sendDefaultPii = true;
    },
  );
  PlatformDispatcher.instance.onError = (error, stack) {
    _recordSentry(error, stack);
    return true;
  };
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    _recordSentry(errorDetails.exception, errorDetails.stack);
  };
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

/// 异常上报sentry
void _recordSentry(Object error, StackTrace? stack) async {
  try {
    Sentry.captureException(error, stackTrace: stack).catchError((e) {
      return const SentryId.empty();
    });
  } catch (e) {
    logger.d(e);
  }
}
