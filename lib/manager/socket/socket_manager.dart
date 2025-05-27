import 'package:get/get.dart';
import '../../common/info.dart';
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
    _socket?.send(message);
  }
}
