import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import '../manager/log_manager.dart';

Future<File> getDownloadFilePath(String filename) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  return File('$dir/$filename');
}

Future<String?> getHivePath(String filename) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  Directory directory = Directory('$dir/hive');
  try {
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
      if (!directory.existsSync()) {
        return null;
      }
    }
    return '${directory.path}$filename';
  } on Exception catch (e) {
    logger.d('getChatImageFilePath Exception ${e.toString()}');
    return null;
  }
}
