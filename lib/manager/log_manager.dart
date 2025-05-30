import 'package:logger/logger.dart';

/// 日志工具
final logger = Logger(filter: MyLogFilter(), printer: MyLogPrinter());

/// 打点类型过滤器
class MyLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (event.level.index < Level.debug.index) {
      return false;
    }
    return true;
  }
}

/// 自定义打点样式
class MyLogPrinter extends PrettyPrinter {
  @override
  int get methodCount => 0;

  @override
  bool get colors => false;

  @override
  Map<Level, bool> get excludeBox => {
        Level.info: true,
      };
}
