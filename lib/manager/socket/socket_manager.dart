import 'package:get/get.dart';
import '../../common/info.dart';
import '../../network/net_request.dart';
import '../global_manager.dart';
import 'my_socket.dart';

class SocketManager {
  static SocketManager? _instance;

  static SocketManager get instance => _instance ??= SocketManager._();

  static MySocket? _socket;

  SocketManager._();

  RxBool get didConnect => (_socket?.isConnect ?? false).obs;

  void init() {
    setup(
      wsUrl: GlobalManager.instance.state.isDev
          ? Info.websocketDevUrl
          : Info.websocketProdUrl,
      loginData: () => net.token,
    );
  }

  void setup({
    required String wsUrl,
    required String Function() loginData,
  }) {
    close();
    _socket = MySocket(
      url: wsUrl,
      loginData: loginData,
    );
    _socket?.connect();
  }

  void close() {
    _socket?.close();
    _socket = null;
  }

  void send(String message) {
    _socket?.send(message);
  }
}
