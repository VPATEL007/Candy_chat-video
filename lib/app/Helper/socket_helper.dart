import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Screens/Chat/Chat.dart';
import 'package:video_chat/utils/local_notifications.dart';

import '../../components/Model/Chat/ChatList.dart';
import '../../getx/chatlist_controller.dart';

class SocketHealper {
  static var shared = SocketHealper();
  ChatListController chatListController = Get.put(ChatListController());

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
        if (chatListController.friendList.isNotEmpty) {
          for (int i = 0; i < chatListController.friendList.length; i++) {
            if (data['sendBy'] ==
                chatListController.friendList[i].user?.id.toString().trim()) {
              chatListController.friendList[i].message =
                  data['listItem']['message'];
              chatListController.friendList[i].unReadCount =
                  data['listItem']['unReadCount'];
              ChatListData value = chatListController.friendList[i];
              chatListController.friendList.removeAt(i);
              chatListController.friendList.insert(0, value);
              chatListController.update();
              print('index: $i');
              break;
            }
          }
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
