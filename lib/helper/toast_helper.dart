import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';

void cleanAllToast() {
  BotToast.cleanAll();
}

void showLoadingToast({double? opacity}) {
  var alpha = 0.1;
  if (opacity != null) {
    alpha = opacity;
  }
  cleanAllToast();
  BotToast.showCustomLoading(
    toastBuilder: (CancelFunc cancelFunc) => Container(
      color: Styles.lightBlue.withOpacity(alpha),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
      ),
    ),
    duration: const Duration(days: 1),
  );
}

void showTipsToast(
  String string, {
  double? durationTime,
  Alignment? alignment = Alignment.center,
  Color? bgColor,
  VoidCallback? onDismiss,
  String iconName = '',
  TextStyle? textStyle,
  double? opacity,
  double? borderRadius,
  TextAlign textAlign = TextAlign.start,
}) {
  int time = 1500;
  if (durationTime != null) {
    time = int.parse((durationTime * 1000).toStringAsFixed(0));
  }
  cleanAllToast();
  BotToast.showCustomNotification(
      toastBuilder: (CancelFunc cancelFunc) => Card(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
            color: bgColor ?? Styles.confirmedBtnColor,
            child: Container(
              decoration: const BoxDecoration(
                color: Styles.transparent,
              ),
              padding: const EdgeInsets.all(
                10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Styles.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      string,
                      textAlign: textAlign,
                      style: textStyle ?? Styles.textNormal(14),
                      maxLines: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
      align: alignment,
      duration: Duration(milliseconds: time),
      onlyOne: true,
      onClose: onDismiss);
}
