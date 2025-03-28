import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_chat/manager/global_manager.dart';

import '../common/common.dart';

void cleanAllToast() {
  if (!GlobalManager.instance.state.allowFirstFrame) {
    return;
  }
  BotToast.cleanAll();
}

void showLoadingToast({double? opacity}) {
  if (!GlobalManager.instance.state.allowFirstFrame) {
    return;
  }
  cleanAllToast();
  BotToast.showCustomLoading(
    toastBuilder: (CancelFunc cancelFunc) => Container(
      color: Styles.lightBlue.withOpacity(opacity ?? 0.1),
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 2.w,
      ),
    ),
    duration: const Duration(days: 1),
  );
}

void showTipsToast(
  String string, {
  int? durationTime,
  Alignment? alignment = Alignment.center,
  Color? bgColor,
  VoidCallback? onClose,
  String iconName = '',
  TextStyle? textStyle,
  double? opacity,
  double? borderRadius,
  TextAlign textAlign = TextAlign.center,
}) {
  if (!GlobalManager.instance.state.allowFirstFrame) {
    return;
  }
  cleanAllToast();
  BotToast.showCustomNotification(
    align: alignment,
    duration: Duration(milliseconds: durationTime ?? 1500),
    onlyOne: true,
    onClose: onClose,
    toastBuilder: (CancelFunc cancelFunc) => Card(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
      color: bgColor ?? Styles.deepBlue,
      child: Container(
        padding: EdgeInsets.all(10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.tips_and_updates_outlined,
              color: Styles.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                string,
                textAlign: textAlign,
                style: textStyle ?? Styles.textNormal(14.w),
                maxLines: 10,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
