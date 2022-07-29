import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Screens/Chat/Chat.dart';
import 'package:video_chat/utils/local_notifications.dart';

class SocketHealper {
  static var shared = SocketHealper();

  static Socket? socket;
  static String currentUserId = '';

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
      socket?.on('getFriendList', (data) {
        print('data==> ${data}');
        LocalNotification.toUserId = data['sendBy'];
        if (data['sendBy'].toString().trim() == currentUserId) {
          return;
        }
        LocalNotification().showMessageNotification(
            data['listItem']['user']['user_name'], data['listItem']['message']);
        print('getFriendList data==> $data');
      });
    });
    socket?.onConnectError((data) {
      print('Socket Connect error $data');
    });
    socket?.onError((data) {
      print('Socket error $data');
    });

    // socket = Socket.fromUpgradedSocket(socket, serverSide: false);
    socket?.connect();
  }

  disconnect() {
    socket?.disconnect();
  }
}
