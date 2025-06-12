import 'package:dio/dio.dart';

typedef JsonConvertor<T> = T Function(Map<String, dynamic>);

class NetworkResponseError {
  Response? response;
  Map<String, dynamic> responseMap;
  JsonConvertor jsonInstance;

  NetworkResponseError(this.response, this.responseMap, this.jsonInstance);
}

typedef NetworkResponseErrorEvent = void Function(NetworkResponseError error);

class NetworkConfig {
  /// 服务器
  String host;

  /// true=使用测试服，false=使用正式服
  bool useDevHost;

  /// 用户token
  String token;
  Function(String token)? updateTokenCallback;

  /// api接口数据加密密钥
  String apiKey;

  bool Function() hasLogin;

  Function()? getCustomHeaders;

  NetworkResponseErrorEvent? handleResponseFromJsonErrorLog;

  Function(Uri? uri, String? requestId, Object? throwable)? onResponseError;

  NetworkConfig({
    required this.apiKey,
    required this.hasLogin,
    this.host = '',
    this.updateTokenCallback,
    this.useDevHost = true,
    this.token = '',
    this.getCustomHeaders,
    this.handleResponseFromJsonErrorLog,
    this.onResponseError,
  });
}

class NetworkHelper {
  static NetworkConfig config = NetworkConfig(
      apiKey: '',
      hasLogin: () {
        return false;
      });

  static NetworkHelper get instance => _instance ?? NetworkHelper._();
  static NetworkHelper? _instance;

  NetworkHelper._();

  setupConfig(NetworkConfig networkConfig) async {
    config = networkConfig;
  }

  /// 有些配置项在用户登录或者退出登录后会改变，需要重置
  void resetConfig(NetworkConfig networkConfig) {
    config = networkConfig;
  }
}
