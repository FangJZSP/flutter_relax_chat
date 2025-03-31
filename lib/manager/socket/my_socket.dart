import 'dart:async';
import 'dart:convert';
import 'package:relax_chat/model/ws/resp/ws_msg_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../user_manager.dart';
import '../../network/net_request.dart';
import '../event_bus_manager.dart';
import '../log_manager.dart';

enum SocketConnectStatus {
  connecting,
  connected,
  disconnect,
}

class MySocket {
  MySocket({
    required this.url,
  });

  final String url;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  static const int _reconnectDelay = 3000; // 重连延迟3秒
  static const int _maxReconnectAttempts = 5; // 最大重连次数
  static const int _heartbeatInterval = 30000; // 心跳间隔30秒
  int _reconnectAttempts = 0;

  Uri get _socketUri => Uri.parse(url);

  WebSocketChannel? _channel;

  StreamSubscription? streamSubscription;

  SocketConnectStatus _connectStatus = SocketConnectStatus.disconnect;

  bool get isConnect => _connectStatus == SocketConnectStatus.connected;

  bool get isDisconnect => _connectStatus == SocketConnectStatus.disconnect;

  bool get isConnecting => _connectStatus == SocketConnectStatus.connecting;

  bool connect() {
    bool result = false;
    if (_channel != null) {
      _channel?.sink.close();
    }
    _setConnectStatus(SocketConnectStatus.connecting);
    try {
      _channel = WebSocketChannel.connect(_socketUri);
      _setConnectStatus(SocketConnectStatus.connected);
      streamSubscription = _channel?.stream.listen(
        (message) {
          _resetReconnectAttempts();
          _onReceiveData(message);
        },
        onError: (error, trace) {
          logger.d('ws onError $error, $trace');
          _handleDisconnect();
        },
        onDone: () {
          logger.d('ws onDone');
          _handleDisconnect();
        },
      );
      _startHeartbeat();
      result = true;
    } catch (e) {
      logger.d('ws 连接异常 $e');
      _handleDisconnect();
      result = false;
    }
    return result;
  }

  void close() {
    _stopReconnect();
    _stopHeartbeat();
    _channel?.sink.close();
    streamSubscription?.cancel();
    logger.d('ws 关闭');
  }

  void _handleDisconnect() {
    _setConnectStatus(SocketConnectStatus.disconnect);
    _stopHeartbeat();
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _startReconnect();
    } else {
      logger.d('ws 重连次数超过最大限制，停止重连');
    }
  }

  void _startReconnect() {
    _stopReconnect();
    _reconnectTimer = Timer(Duration(milliseconds: _reconnectDelay), () {
      if (isDisconnect) {
        _reconnectAttempts++;
        logger.d('ws 开始第 $_reconnectAttempts 次重连');
        connect();
      }
    });
  }

  void _stopReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void _resetReconnectAttempts() {
    _reconnectAttempts = 0;
  }

  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(
      Duration(milliseconds: _heartbeatInterval),
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

  void _sendHeartbeat() {
    try {
      send(json.encode({'type': 'ping'}));
    } catch (e) {
      logger.d('ws 发送心跳失败: $e');
      _handleDisconnect();
    }
  }

  void _onReceiveData(dynamic message) {
    logger.d('ws 收到消息 $message');
    WSBaseResponseModel wsBaseModel =
        WSBaseResponseModel.fromJson(json.decode(message));
    dynamic wsModel;
    switch (WSRespTypeEnum.fromType(wsBaseModel.type)) {
      case WSRespTypeEnum.newMessage:
        wsModel = WSMessageModel.fromJson(wsBaseModel.res);
        eventBus.fire(WSReceivedMsgEvent(wsModel));
        break;
      case null:
        break;
      case WSRespTypeEnum.loginUrl:
        break;
      case WSRespTypeEnum.loginScanSuccess:
        break;
      case WSRespTypeEnum.loginSuccess:
        wsModel = WSLoginSuccessModel.fromJson(wsBaseModel.res);
        net.updateTokenCallback((wsModel as WSLoginSuccessModel).token);
        UserManager.instance.loadUser();
        eventBus.fire(WSLoginSuccessEvent(wsModel));
        break;
      case WSRespTypeEnum.onlineOfflineNotify:
        break;
      case WSRespTypeEnum.invalidToken:
        UserManager.instance.logOut();
        break;
      case WSRespTypeEnum.black:
        break;
      case WSRespTypeEnum.mark:
        break;
      case WSRespTypeEnum.recall:
        break;
      case WSRespTypeEnum.apply:
        break;
      case WSRespTypeEnum.memberChange:
        break;
      case WSRespTypeEnum.loginEmail:
        break;
      default:
        logger.d('ws 未处理接收数据');
    }
    _handleWSMessage(wsModel);
  }

  // 向服务器发送消息
  void send(String message) {
    _channel?.sink.add(message);
  }

  // todo 收敛分发信息
  void _handleWSMessage(dynamic model) {}

  void _setConnectStatus(SocketConnectStatus value) {
    if (value == _connectStatus) {
      return;
    }
    _connectStatus = value;
    if (isConnect) {
      logger.d('ws 连接成功');
    } else if (isConnecting) {
      logger.d('ws 连接中...');
    } else if (isDisconnect) {
      logger.d('ws 连接异常');
    }
  }
}
