import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:video_chat/components/Screens/Chat/Chat.dart';

import '../app/utils/navigator.dart';
import '../components/Model/Notification/NotificatonModel.dart';
import '../components/Model/User/UserModel.dart';
import '../components/Screens/UserProfile/UserProfile.dart';

// import 'package:timezone/timezone.dart' as tz;
// import 'package:rxdart/rxdart.dart';

class LocalNotification {
  // static final _notifications = FlutterLocalNotificationsPlugin();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static String toUserId = '';

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      if (payload == 'message') {
        NavigationUtilities.push(Chat(
          toUserId: int.parse(toUserId),
          isNotification: true,
        ));
      }
      print('payload==> $payload');
    });
  }

  showMessageNotification(userName, message) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            ticker: 'ticker');
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(subtitle: 'the subtitle');
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, userName, message, platformChannelSpecifics,
        payload: 'message');
  }

  void showNotification(RemoteNotification? message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'high_importance_channel' : 'com.sugarcam.videochat',
      'This channel is used for important notifications.',
      '',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(subtitle: 'the subtitle');
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, message?.title, message?.body, platformChannelSpecifics,
        payload: 'data');
    print("Show Notification");
  }

  openNotification(RemoteMessage message) {
    NotificationModel model = NotificationModel.fromJson(message.data);
    if (model.type == "follow") {
      NavigationUtilities.push(UserProfile(
        userModel: UserModel(id: int.parse(model.userId ?? "")),
      ));
    }
  }
}
