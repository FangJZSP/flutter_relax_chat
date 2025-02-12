import 'package:relax_chat/manager/user_manager.dart';
import 'package:relax_chat/manager/database/dao/local_box_dao.dart';
import 'package:relax_chat/manager/database/dao/user_box_dao.dart';

import 'dao/cache_file_box_dao.dart';
import 'dao/im_box_dao.dart';

class DaoManager {
  static DaoManager get instance => _instance ??= DaoManager._();
  static DaoManager? _instance;

  DaoManager._();

  Future<void> init() async {
    await LocalBoxDao.instance.init();
    if (!UserManager.instance.state.hasLogin) {
      return;
    }
    await UserBoxDao.instance.init();
    await ImBoxDao.instance.init();
    await CacheFileBoxDao.instance.init();
  }

  Future<void> close() async {
    await LocalBoxDao.instance.close();
    await UserBoxDao.instance.close();
    await ImBoxDao.instance.close();
    await CacheFileBoxDao.instance.close();
  }
}
