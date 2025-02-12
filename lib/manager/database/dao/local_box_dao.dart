import '../base/base_box.dart';
import '../base/base_dao.dart';

class LocalBoxDao extends BaseDao {
  static LocalBoxDao get instance => _instance ??= LocalBoxDao._();
  static LocalBoxDao? _instance;

  LocalBoxDao._();

  BaseBox<String>? localBox;

  String? get(String key) {
    return localBox?.get(key);
  }

  Future<void> set(String key, String? data) async {
    if (data == null) {
      return;
    }
    await localBox?.set(key, data);
  }

  @override
  Future<void> init() async {
    localBox = BaseBox<String>(
      'LocalBox',
      null,
      null,
    );
    await localBox?.initBox();
  }

  @override
  Future<void> close() async {
    await localBox?.closeBox();
  }
}
