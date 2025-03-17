import 'dart:ui';

import 'package:get/get.dart';

import '../../../model/cache_file_model.dart';
import '../base/base_box.dart';
import '../base/base_dao.dart';

/// 缓存文件管理
class CacheFileBoxDao implements BaseDao {
  static CacheFileBoxDao get instance => _instance ??= CacheFileBoxDao._();
  static CacheFileBoxDao? _instance;

  final String _boxName = 'CacheFileBox';

  CacheFileBoxDao._();

  BaseBox<CacheFileModel>? cacheFileBox;

  @override
  Future<void> init() async {
    cacheFileBox = BaseBox<CacheFileModel>(
      _boxName,
      CacheFileModel.fromJson,
      (model) => model.toJson(),
    );
    await cacheFileBox?.initBox();
    // 初始化时，刷新缓存
    refreshCacheFiles();
  }

  @override
  Future<void> close() async {
    await cacheFileBox?.closeBox();
  }

  /// 获取所有的缓存文件
  List<CacheFileModel> get getCacheFiles {
    List<String>? urls = cacheFileBox?.getKeys();
    List<CacheFileModel> list = [];

    if (urls != null) {
      for (var e in urls) {
        CacheFileModel? model = cacheFileBox?.get(e);
        list.addIf(model != null, model!);
      }
    }
    return list;
  }

  /// 刷新缓存文件，7天未使用的文件会被清理
  void refreshCacheFiles() {
    List<String>? urls = cacheFileBox?.getKeys();

    int now = DateTime.now().millisecondsSinceEpoch;

    if (urls != null) {
      for (var url in urls) {
        CacheFileModel? model = cacheFileBox?.get(url);
        if ((model?.saveTime ?? 0) < now) {
          delCacheFile(url);
        }
      }
    }
  }

  /// 根据url获取缓存文件
  CacheFileModel? getCacheFile(String url, {bool needRefresh = false}) {
    CacheFileModel? model = cacheFileBox?.get(url);
    if (model != null && needRefresh) {
      // 当前文件被使用过，则刷新保存时间
      model.saveTime =
          DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch;
      setCacheFile(model);
    }
    return model;
  }

  /// 更新缓存列表 适用于大批量更新缓存文件
  void updateCacheFileList(List<CacheFileModel> models) {
    for (var model in models) {
      cacheFileBox?.set(model.url, model);
    }
  }

  /// 保存缓存文件
  void setCacheFile(CacheFileModel model) {
    cacheFileBox?.set(model.url, model);
  }

  /// 删除缓存文件 & 物理删除
  void delCacheFile(String url) async {
    CacheFileModel? model = getCacheFile(url);
    if (model != null) {
      // await deleteFileFromCache(model);
    }
    cacheFileBox?.delete(url);
  }
}
