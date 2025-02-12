import 'dart:convert';

///定义响应类
class Result<T> {
  T? data;
  int? code;
  String? message;

  /// 原始数据
  dynamic responseData;

  Result(
    this.data,
    this.code,
    this.message,
    this.responseData,
  );

  factory Result.success(T? data, int? code, {dynamic responseMap}) =>
      Result(data, code, null, responseMap);

  factory Result.fail(int errCode, String? errMsg, {dynamic responseMap}) =>
      Result(null, errCode, errMsg, responseMap);

  bool get result => code == 0;

  @override
  String toString() {
    return 'code = $code, data = ${jsonEncode(data)}, errMsg = $message';
  }
}
