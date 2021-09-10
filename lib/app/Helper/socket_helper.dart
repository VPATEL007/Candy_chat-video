import 'package:socket_io_client/socket_io_client.dart';
import 'package:video_chat/app/app.export.dart';

class SocketHealper {
  static var shared = SocketHealper();

  Socket socket;

  connect() async {
    if (app.resolve<PrefUtils>().isUserLogin() == false) return;
    if (socket?.connected == true) return;

    socket = io(
        ApiConstants.socketUrl,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect()
            .enableForceNew()
            .setQuery({
              "Authorization":
                  "Bearer " + app.resolve<PrefUtils>().getUserToken()
            }) // optional
            .build());

    socket?.onConnect((_) {
      print('Socket connected');
    });
    socket?.onConnectError((data) {
      print('Socket Connect error $data');
    });
    socket?.onError((data) {
      print('Socket error $data');
    });

    socket.connect();
  }

  disconnect() {
    // socket?.disconnect();
  }
}
