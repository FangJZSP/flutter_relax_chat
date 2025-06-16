import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../common/common.dart';
import '../route/routes.dart';

class DropMenuItem {
  const DropMenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

class DropMenuItems {
  static const List<DropMenuItem> messagePageItems = [add, scan];

  static const add = DropMenuItem(
    text: '加好友/群',
    icon: Icons.person_add_alt,
  );
  static const scan = DropMenuItem(
    text: '扫一扫',
    icon: Icons.qr_code_scanner_sharp,
  );

  static Widget buildItem(DropMenuItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          item.icon,
          color: Styles.black,
          size: 24.w,
        ),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
          child: Text(
            item.text,
            style:
                Styles.textFiraNormal(16.w).copyWith(color: Styles.blackText),
          ),
        ),
      ],
    );
  }

  static Future<void> onChanged(BuildContext context, DropMenuItem item) async {
    switch (item) {
      case DropMenuItems.add:
        Get.toNamed(Routes.add);
        break;
      case DropMenuItems.scan:
        //Do something
        try {
          throw StateError('Sentry Test Exception');
        } catch (exception, stackTrace) {
          await Sentry.captureException(
            exception,
            stackTrace: stackTrace,
          );
        }
        break;
    }
  }
}
