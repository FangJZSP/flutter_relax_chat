import 'package:flutter/material.dart';

class Styles {
  /// 基本色
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color red = Colors.red;

  /// 定制色
  static const Color deepBlue = Color.fromRGBO(20, 60, 154, 1);
  static const Color normalBlue = Color.fromRGBO(50, 110, 252, 1);
  static const Color lightBlue = Color.fromRGBO(121, 187, 235, 1);
  static const Color coverBlue = Color.fromRGBO(66, 81, 98, 1);

  /// app
  static const Color appNameColor = Colors.deepOrange;
  static const Color appBarColor = Color.fromRGBO(251, 251, 251, 1);

  /// bg
  static const Color navigationBarColor = Color.fromRGBO(250, 250, 250, 1);
  static const Color bgColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color greyBgColor = Color.fromRGBO(242, 242, 242, 1);

  /// 消息气泡
  static const Color receiveBubbleColor = Color.fromRGBO(237, 239, 247, 1);
  static const Color sendBubbleColor = Color.fromRGBO(209, 227, 255, 1);

  /// 按钮
  static const Color unconfirmedBtnColor = Color.fromRGBO(209, 227, 255, 1);
  static const Color confirmedBtnColor = Color.fromRGBO(20, 60, 154, 1);

  /// 字体
  static const Color blackText = Colors.black;
  static const Color whiteText = Colors.white;
  static const Color greyText = Colors.grey;

  static TextStyle textLight(double size) {
    return TextStyle(fontSize: size, color: white, fontWeight: FontWeight.w300);
  }

  static TextStyle textNormal(double size) {
    return TextStyle(fontSize: size, color: white, fontWeight: FontWeight.w500);
  }

  static TextStyle textBold(double size) {
    return TextStyle(fontSize: size, color: white, fontWeight: FontWeight.w900);
  }
}
