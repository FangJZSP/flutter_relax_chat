import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:relax_chat/model/ws/resp/ws_msg_model.dart';
import 'package:relax_chat/pages/root/root_logic.dart';
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
      streamSubscription = _channel?.stream.listen((message) {
        _onReceiveData(message);
      }, onError: (error, trace) {
        _setConnectStatus(SocketConnectStatus.disconnect);
        logger.d('ws onError $error, $trace');
      }, onDone: () {
        logger.d('ws onDone');
      });
      result = true;
    } catch (e) {
      logger.d('ws 连接异常 $e');
      _setConnectStatus(SocketConnectStatus.disconnect);
      result = false;
    }

    return result;
  }

  void close() {
    _channel?.sink.close();
    logger.d('ws 关闭');
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
        Get.find<RootLogic>().backToLogin();
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
