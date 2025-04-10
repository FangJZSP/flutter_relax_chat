import 'dart:ui';

import 'package:flutter/material.dart';

class SizeConfig {
  static late Orientation orientation;

  // static FlutterView view =
  //     WidgetsBinding.instance.platformDispatcher.views.first;
  //
  // static double get screenWidth =>
  //     view.physicalSize.width / view.devicePixelRatio;
  //
  // static double get screenHeight =>
  //     view.physicalSize.height / view.devicePixelRatio;
  //
  // static double get topMargin => view.padding.top / view.devicePixelRatio;
  //
  // static double get bottomMargin => view.padding.bottom / view.devicePixelRatio;

  static double get screenWidth =>
      window.physicalSize.width / window.devicePixelRatio;

  static double get screenHeight =>
      window.physicalSize.height / window.devicePixelRatio;

  static double get topMargin => window.padding.top / window.devicePixelRatio;

  static double get bottomMargin =>
      window.padding.bottom / window.devicePixelRatio;

  /// 导航栏高度
  static double get navBarHeight => 48.w;

  /// 内容边距
  static double get bodyPadding => 16.w;

  static bool get isPad => SizeConfig.screenWidth > 700;

  static bool get isSmallPhone => SizeConfig.screenHeight < 700;

  // Get the proportionate height as per screen size
  static double getProportionateScreenHeight(double inputHeight) {
    double screenHeight = SizeConfig.screenHeight;
    // 812 is the layout height that designer use
    return (inputHeight / 812.0) * screenHeight;
  }

  // Get the proportionate height as per screen size
  static double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = SizeConfig.screenWidth;
    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }

  static double getProportionateScreenScale(double value) {
    double screenWidth = SizeConfig.screenWidth;
    double screenHeight = SizeConfig.screenHeight;
    double scaleWidth = (screenWidth / 375.0);
    double scaleHeight = (screenHeight / 812.0);
    double scale = scaleWidth > scaleHeight ? scaleHeight : scaleWidth;
    return scale * value;
  }
}

extension SizeConfigPt on num {
  /// 根据屏幕宽高比例，谁小按照谁缩放
  double get pt => SizeConfig.getProportionateScreenScale(toDouble());

  /// 根据屏幕高度等比例缩放 height
  double get h => SizeConfig.getProportionateScreenHeight(toDouble());

  /// 根据屏幕宽度等比例缩放 width
  double get w => SizeConfig.getProportionateScreenWidth(toDouble());
}
