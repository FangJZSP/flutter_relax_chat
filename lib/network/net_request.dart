import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:relax_chat/manager/database/base/keys.dart';
import 'package:relax_chat/manager/database/dao/local_box_dao.dart';
import 'package:relax_chat/network/network_helper.dart';
import 'package:relax_chat/network/result.dart';
import 'package:relax_chat/network/crypto_helper.dart';
import '../manager/log_manager.dart';

final net = Net();

class Net {
  final _dio = Dio();

  String token = '';

  void updateTokenCallback(String data) {
    if (data.isEmpty) {
      return;
    }
    token = data;
    LocalBoxDao.instance.set(userTokenKey, data);
  }

  /// 加密请求数据
  String _encryptRequestData(Map<String, dynamic>? params) {
    if (params == null) {
      return CryptoHelper.encryptJson({});
    }
    return CryptoHelper.encryptJson(params);
  }

  /// 获取请求头
  Future<Map<String, dynamic>> getHeader(
      String url, String dataForSignature, bool isEncrypted) async {
    Map<String, dynamic> headers = {};
    if (token.isNotEmpty) {
      headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    headers.putIfAbsent('x-encrypted', () => isEncrypted ? 'true' : 'false');
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    headers.putIfAbsent('x-timestamp', () => timestamp.toString());
    String signature =
        CryptoHelper.generateSignature(dataForSignature, timestamp.toString());
    logger.d('url $signature');
    headers.putIfAbsent('x-signature', () => signature);
    headers['Content-Type'] = 'application/json';
    return headers;
  }

  /// 处理参数
  Map<String, dynamic>? handleParams(Map<String, dynamic>? params) {
    if (params == null) {
      return null;
    }
    return params;
  }

  /// 处理请求结果
  Result<T> handleResponse<T>(
    Response? response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    Map responseMap = {};
    if (response != null && response.data is Map) {
      responseMap = response.data;
    } else if (response != null && response.data is String) {
      try {
        final timestamp = response.headers.value('x-timestamp') ?? '';
        final signature = response.headers.value('x-signature') ?? '';
        if (timestamp.isNotEmpty && signature.isNotEmpty) {
          if (!CryptoHelper.verifySignature(
              response.data, timestamp, signature)) {
            return Result.fail(400, '响应签名验证失败', responseMap: null);
          }
        }
        responseMap = CryptoHelper.decryptJson(response.data);
      } catch (e) {
        logger.e('解密响应失败: $e');
        return Result.fail(400, '解密响应失败', responseMap: null);
      }
    }

    Result<T> result;
    if (response?.statusCode == 200) {
      var data = responseMap['data'];
      if (data == null) {
        result =
            Result.success(null, responseMap['code'], responseMap: responseMap);
      } else if (fromJson != null && data is Map<String, dynamic>) {
        result = Result.success(fromJson.call(data), responseMap['code'],
            responseMap: responseMap);
      } else if (fromJson == null && data is T) {
        result =
            Result.success(data, responseMap['code'], responseMap: responseMap);
      } else {
        result =
            Result.fail(23333, 'data type error', responseMap: responseMap);
      }
    } else {
      result = Result.fail(responseMap['code'] ?? 400, responseMap['message'],
          responseMap: responseMap);
    }
    return result;
  }

  Future<Result<T>> postRequest<T>(
    url,
    Map<String, dynamic>? params, {
    T Function(Map<String, dynamic>)? fromJson,
    bool needLogin = false,
  }) async {
    params = handleParams(params);
    bool shouldEncrypt = !NetworkHelper.config.useDevHost;
    String dataForSignature = params != null ? jsonEncode(params) : '{}';
    dynamic requestData;
    if (shouldEncrypt) {
      requestData = _encryptRequestData(params);
    } else {
      requestData = params;
    }

    Map<String, dynamic> header =
        await getHeader(url, dataForSignature, shouldEncrypt);
    Response? response;
    Options options = Options()
      ..method = 'POST'
      ..receiveTimeout = const Duration(milliseconds: 10000)
      ..headers = header;

    Result<T> resultData;
    DioException? error;
    DateTime startTime = DateTime.now();

    try {
      response = await _dio.post(url, data: requestData, options: options);
      resultData = handleResponse(response, fromJson);
    } on DioException catch (e) {
      error = e;
      if (e.response != null) {
        resultData = handleResponse<T>(e.response, fromJson);
      } else {
        resultData = Result.fail(400, error.message, responseMap: null);
      }
    }

    int responseTime = DateTime.now().difference(startTime).inMilliseconds;
    if (resultData.ok) {
      logger.d('POST 成功 $url ${response?.statusCode}');
    } else {
      logger.d('POST 失败 $url $resultData');
    }
    logger.d('POST 消耗 ${responseTime / 1000}秒 ');

    return resultData;
  }

  Future<Result<T>> getRequest<T>(
    String url,
    Map<String, dynamic>? params, {
    T Function(Map<String, dynamic>)? fromJson,
    bool needLogin = false,
  }) async {
    params = handleParams(params);
    bool shouldEncrypt = !NetworkHelper.config.useDevHost;
    String dataForSignature = params != null ? jsonEncode(params) : '{}';

    Response? response;
    Map<String, dynamic> header =
        await getHeader(url, dataForSignature, shouldEncrypt);
    Options options = Options()
      ..method = 'GET'
      ..headers = header;

    Result<T> resultData;
    DioException? error;
    DateTime startTime = DateTime.now();

    try {
      if (needLogin) {
        resultData = Result.fail(400, null, responseMap: null);
      } else {
        response =
            await _dio.get(url, queryParameters: params, options: options);
        resultData = handleResponse(response, fromJson);
      }
    } on DioException catch (e) {
      error = e;
      resultData = Result.fail(400, error.message, responseMap: null);
    }

    int responseTime = DateTime.now().difference(startTime).inMilliseconds;
    if (resultData.ok) {
      logger.d('GET 成功 $url ${response?.statusCode}');
    } else {
      logger.d('GET 失败 $url $resultData');
    }
    logger.d('GET 消耗 ${responseTime / 1000}秒 ');

    return resultData;
  }
}
