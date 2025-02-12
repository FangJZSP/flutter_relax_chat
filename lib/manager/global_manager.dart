import '../route/routes.dart';
import 'log_manager.dart';

class GlobalManager {
  GlobalManager._() {
    logger.d('GlobalManager init');
  }

  static GlobalManager get instance => _instance ??= GlobalManager._();
  static GlobalManager? _instance;

  final GlobalState state = GlobalState();
}

class GlobalState {
  bool isDev = false;

  String firstRoute = Routes.home;

  GlobalState() {
    ///Initialize variables
  }
}
