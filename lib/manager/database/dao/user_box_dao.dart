import 'package:relax_chat/model/user_model.dart';
import '../../user_manager.dart';
import '../base/base_box.dart';
import '../base/base_dao.dart';

class UserBoxDao extends BaseDao {
  static UserBoxDao get instance => _instance ??= UserBoxDao._();
  static UserBoxDao? _instance;

  UserBoxDao._();

  BaseBox<UserModel>? userBox;

  UserModel? query(String userId) {
    return userBox?.get(userId);
  }

  Future<void> update(UserModel? user) async {
    if (user == null) {
      return;
    }
    await userBox?.set(user.uid.toString(), user);
  }

  @override
  Future<void> init() async {
    userBox = BaseBox<UserModel>(
      '${UserManager.instance.state.user.value.uid}_userInfoBox',
      UserModel.fromJson,
      (model) => model.toJson(),
    );
    await userBox?.initBox();
  }

  @override
  Future<void> close() async {
    await userBox?.closeBox();
  }
}
