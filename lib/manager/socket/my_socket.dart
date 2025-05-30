import 'dart:async';
import 'dart:convert';
import 'package:relax_chat/model/ws/req/ws_base_req.dart';
import 'package:relax_chat/model/ws/resp/ws_msg_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../model/ws/req/ws_token_req.dart';
import '../../model/ws/resp/ws_base_res.dart';
import '../event_bus_manager.dart';
import '../log_manager.dart';

const int reconnectDelay = 3000; // 重连延迟3秒
const int maxReconnectAttempts = 5; // 最大重连次数
const int heartbeatInterval = 30000; // 心跳间隔30秒
const int maxBadHeartbeatCount = 3; // 最大bad心跳

enum SocketConnectStatus {
  connecting,
  connected,
  disconnect,
}

class MySocket {
  final String url;
  final String Function() loginData;

  MySocket({
    required this.url,
    required this.loginData,
  });

  WebSocketChannel? _channel;

  StreamSubscription? wsStreamSub;

  SocketConnectStatus _connectStatus = SocketConnectStatus.disconnect;

  Timer? _reconnectTimer;

  Timer? _heartbeatTimer;

  /// 心跳计数
  int _heartBeatSeq = 0;

  /// 最近一次发送心跳是否成功收到回复
  bool _lastHeartBeatSuccess = false;

  /// 本实例自创建以来，心跳超时未收到回复的次数
  int _badHeartBeatCount = 0;

  /// 本实例自创建以来，心跳正常的次数
  int _goodHeartBeatCount = 0;

  /// 本实例自创建以来，重连的次数
  int _channelReconnectTimes = -1;

  /// 连接成功平均耗时
  int _connectDurationMs = 0;

  DateTime? _startConnectTime;

  int get badHeartBeatCount => _badHeartBeatCount;

  int get goodHeartBeatCount => _goodHeartBeatCount;

  int get channelReconnectTimes => _channelReconnectTimes;

  int get connectDurationMs => _connectDurationMs;

  bool get isConnect => _connectStatus == SocketConnectStatus.connected;

  bool get isDisconnect => _connectStatus == SocketConnectStatus.disconnect;

  bool get isConnecting => _connectStatus == SocketConnectStatus.connecting;

  Uri get _socketUri => Uri.parse(url);

  bool connect() {
    _startConnectTime = DateTime.now();
    _channelReconnectTimes++;
    bool result = false;
    if (_channel != null) {
      _channel?.sink.close();
    }
    _setConnectStatus(SocketConnectStatus.connecting);
    try {
      _channel = WebSocketChannel.connect(_socketUri);
      wsStreamSub = _channel?.stream.listen(
        (message) {
          _resetReconnectAttempts();
          _onReceiveData(message);
        },
        onError: (error, trace) {
          logger.d(
              'ws onError $error, $trace, 重连次数: $_channelReconnectTimes, 平均连接耗时: ${_connectDurationMs}ms');
          _handleDisconnect();
        },
        onDone: () {
          logger.d(
              'ws onDone, 重连次数: $_channelReconnectTimes, 平均连接耗时: ${_connectDurationMs}ms');
          _handleDisconnect();
        },
      );
      _startHeartbeat();
      result = true;
    } catch (e) {
      logger.d('ws 连接异常 $e, 重连次数: $_channelReconnectTimes');
      _handleDisconnect();
      result = false;
    }
    return result;
  }

  void _sendHeartbeat() {
    if (_heartBeatSeq > 0) {
      if (_lastHeartBeatSuccess) {
        _goodHeartBeatCount++;
        logger.d(
            'ws 心跳正常, 成功次数: $_goodHeartBeatCount, 失败次数: $_badHeartBeatCount');
      } else {
        _badHeartBeatCount++;
        logger.d(
            'ws 心跳检测失败, 成功次数: $_goodHeartBeatCount, 失败次数: $_badHeartBeatCount');
        // 如果连续多次心跳失败，主动触发重连
        if (_badHeartBeatCount > maxBadHeartbeatCount) {
          _handleDisconnect();
          return;
        }
      }
    }
    _lastHeartBeatSuccess = false;
    _heartBeatSeq++;
    try {
      send(json.encode({'type': WSReqType.heartbeat.type}));
    } catch (e) {
      logger.d('ws 发送心跳失败: $e');
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    _setConnectStatus(SocketConnectStatus.disconnect);
    _stopHeartbeat();
    wsStreamSub?.cancel();
    _channel?.sink.close();

    // 根据心跳状态决定是否需要重连
    bool shouldReconnect = _badHeartBeatCount > maxBadHeartbeatCount ||
        _channelReconnectTimes < maxReconnectAttempts;

    if (shouldReconnect) {
      _startReconnect();
    } else {
      logger.d(
          'ws 停止重连, 重连次数: $_channelReconnectTimes, 心跳失败次数: $_badHeartBeatCount');
    }
  }

  void _setConnectStatus(SocketConnectStatus value) {
    if (value == _connectStatus) {
      return;
    }
    _connectStatus = value;
    if (isConnect) {
      if (_startConnectTime != null) {
        _connectDurationMs =
            DateTime.now().difference(_startConnectTime!).inMilliseconds;
      }
      logger.d(
          'ws 连接成功, 重连次数: $_channelReconnectTimes, 平均连接耗时: ${_connectDurationMs}ms');

      // 连接成功后执行鉴权
      WSTokenReq wsReq =
          WSTokenReq(WSReqType.authorize.type, TokenData(loginData()));
      send(jsonEncode(wsReq.toJson()));
    } else if (isConnecting) {
      logger.d('ws 连接中..., 当前重连次数: $_channelReconnectTimes');
    } else if (isDisconnect) {
      logger.d(
          'ws 连接断开, 心跳成功次数: $_goodHeartBeatCount, 失败次数: $_badHeartBeatCount');
    }
  }

  void close() {
    _stopReconnect();
    _stopHeartbeat();
    _channel?.sink.close();
    wsStreamSub?.cancel();
    logger.d('ws 关闭');
  }

  /// 开始重连
  void _startReconnect() {
    _stopReconnect();
    _reconnectTimer = Timer(const Duration(milliseconds: reconnectDelay), () {
      if (isDisconnect) {
        _channelReconnectTimes++;
        logger.d('ws 开始第 $_channelReconnectTimes 次重连');
        connect();
      }
    });
  }

  void _stopReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void _resetReconnectAttempts() {
    _channelReconnectTimes = 0;
  }

  /// 开启心跳检测机制
  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(
      const Duration(milliseconds: heartbeatInterval),
      (timer) {
        if (isConnect) {
          _sendHeartbeat();
        }
      },
    );
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void _onReceiveData(dynamic message) {
    logger.d('ws 收到消息 $message');
    WSBaseResponseModel wsBaseModel =
        WSBaseResponseModel.fromJson(json.decode(message));
    switch (WSResType.fromType(wsBaseModel.type)) {
      case WSResType.newMessage:
        eventBus
            .fire(WSReceivedMsgEvent(WSMessageModel.fromJson(wsBaseModel.res)));
        break;
      case WSResType.loginUrl:
        break;
      case WSResType.loginScanSuccess:
        break;
      case WSResType.loginSuccess:
        eventBus.fire(
            WSLoginSuccessEvent(WSLoginSuccessModel.fromJson(wsBaseModel.res)));
        break;
      case WSResType.onlineOfflineNotify:
        break;
      case WSResType.invalidToken:
        eventBus.fire(WSInvalidTokenEvent());
        break;
      case WSResType.block:
        break;
      case WSResType.mark:
        break;
      case WSResType.recall:
        break;
      case WSResType.apply:
        break;
      case WSResType.memberChange:
        break;
      case WSResType.loginEmail:
        break;
      case WSResType.heartBeat:
        _lastHeartBeatSuccess = true;
        break;
      case WSResType.connectSuccess:
        if (isConnecting) {
          _setConnectStatus(SocketConnectStatus.connected);
        }
        break;
      default:
        logger.d('ws 未处理接收数据');
    }
  }

  /// 向服务器发送消息
  void send(String message) {
    _channel?.sink.add(message);
  }

  // 添加获取连接状态信息的方法
  Map<String, dynamic> getConnectionStats() {
    return {
      'reconnectTimes': _channelReconnectTimes,
      'avgConnectTime': _connectDurationMs,
      'goodHeartbeats': _goodHeartBeatCount,
      'badHeartbeats': _badHeartBeatCount,
      'currentStatus': _connectStatus.toString(),
    };
  }
}
