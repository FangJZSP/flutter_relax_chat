import 'package:get/get.dart';
import 'package:relax_chat/helper/toast_helper.dart';

import '../../common/info.dart';
import '../global_manager.dart';
import 'my_socket.dart';

class SocketManager {
  static SocketManager get instance => _getInstance();
  static SocketManager? _instance;

  static SocketManager _getInstance() {
    _instance ??= SocketManager._();
    return _instance!;
  }

  SocketManager._();

  static MySocket? _socket;

  RxBool get didConnect => (_socket?.isConnect ?? false).obs;

  void init() {
    setup(
      wsUrl: GlobalManager.instance.state.isDev
          ? Info.websocketDevUrl
          : Info.websocketProdUrl,
    );
  }

  void setup({
    required String wsUrl,
  }) {
    close();
    _socket = MySocket(
      url: wsUrl,
    );
    _socket?.connect();
  }

  void close() {
    _socket?.close();
    _socket = null;
  }

  void send(String message) {
    if (!didConnect.value) {
      showTipsToast('ws 断连中...');
      return;
    }
    _socket?.send(message);
  }
}
