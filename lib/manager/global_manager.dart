import 'package:flutter/material.dart';

import '../route/routes.dart';
import 'log_manager.dart';

class GlobalManager {
  GlobalManager._() {
    logger.d('GlobalManager init');
  }

  static GlobalManager get instance => _instance ??= GlobalManager._();
  static GlobalManager? _instance;

  final GlobalState state = GlobalState();

  ///将方法推迟至应用第一帧绘制完成时执行，若已绘制完成则立即执行
  void doFirstFrameCallback(Function()? function) {
    if (state.allowFirstFrame) {
      function?.call();
    } else {
      state.waitFirstFrameBack.add(function);
    }
  }
}

class GlobalState {
  bool isDev = false;

  String firstRoute = Routes.home;

  /// 存储页面绘制后回调的各方法
  final List<Function()?> waitFirstFrameBack = [];

  bool _allowFirstFrame = false;

  /// 获取当前第一帧是否已经绘制
  bool get allowFirstFrame => _allowFirstFrame;

  /// allowFirstFrame每次启动仅会一次被设置为true
  set allowFirstFrame(bool allow) {
    if (!_allowFirstFrame && allow) {
      _allowFirstFrame = true;
      WidgetsBinding.instance.allowFirstFrame();
      for (var element in waitFirstFrameBack) {
        element?.call();
      }
    }
  }

  GlobalState() {
    ///Initialize variables
  }
}
