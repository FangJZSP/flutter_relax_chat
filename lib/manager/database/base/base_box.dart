import 'dart:convert';

import 'package:hive/hive.dart';

import '../../../helper/file_path_helper.dart';
import '../../log_manager.dart';

class BaseBox<T> {
  final String boxName;

  final T Function(Map<String, dynamic> json)? fromJson;

  final Map<String, dynamic> Function(T model)? toJson;

  BaseBox(this.boxName, this.fromJson, this.toJson);

  Box? _baseBox;

  bool get _isOpen => _baseBox?.isOpen ?? false;

  Future<void> initBox() async {
    String? boxPath = await getHivePath(boxName);
    if (boxPath != null && boxPath.isNotEmpty) {
      _baseBox = await Hive.openBox(boxName, path: boxPath);
    }
  }

  Future<void> closeBox() async {
    await _baseBox?.close();
    _baseBox = null;
  }

  T? get(String key) {
    if (!_isOpen) {
      return null;
    }
    dynamic value = _baseBox!.get(key, defaultValue: null);
    return _valueToModel(value);
  }

  Future<void> set(String key, T value) async {
    if (!_isOpen) {
      return;
    }
    await _baseBox!
        .put(key, jsonEncode(toJson != null ? toJson?.call(value) : value));
  }

  Future<void> delete(String key) async {
    if (!_isOpen) {
      return;
    }
    await _baseBox!.delete(key);
  }

  List<String> getKeys() {
    if (!_isOpen) {
      return [];
    }
    return _baseBox!.keys.toList().cast();
  }

  List<T> getList({bool Function(T model)? where}) {
    if (!_isOpen) {
      return [];
    }
    Iterable<T?> allList = _baseBox!.values.map((e) => _valueToModel(e));
    Iterable<T?> filterList =
        allList.where((e) => e != null && (where == null || where.call(e)));
    return filterList.toList().cast();
  }

  T? _valueToModel(dynamic value) {
    if (value == null || value is! String) {
      return null;
    }
    try {
      if (fromJson != null) {
        return fromJson?.call(jsonDecode(value));
      } else {
        return jsonDecode(value);
      }
    } catch (e) {
      logger.d(
          'FailedToDecodeBoxData -> boxName : $boxName, value : $value, error: $e');
      return null;
    }
  }
}
