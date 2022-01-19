import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Notification/NotificatonModel.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Splash/Splash.dart';

import 'package:video_chat/provider/chat_provider.dart';
import 'package:video_chat/provider/discover_provider.dart';
import 'package:video_chat/provider/favourite_provider.dart';
import 'package:video_chat/provider/feedback_provider.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/gift_provider.dart';
import 'package:video_chat/provider/language_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/payment_history.dart';
import 'package:video_chat/provider/report_and_block_provider.dart';
import 'package:video_chat/provider/tags_provider.dart';
import 'package:video_chat/provider/video_call_status_provider.dart';
import 'package:video_chat/provider/visitor_provider.dart';
import 'package:video_chat/provider/withdraw_provider.dart';

import 'app/Helper/Themehelper.dart';
import 'app/constant/constants.dart';
import 'app/di/app_module.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/global_models_provider.dart';
import 'app/theme/settings_models_provider.dart';
import 'app/utils/navigator.dart';
import 'app/utils/pref_utils.dart';
import 'app/utils/route_observer.dart';
import 'components/Screens/UserProfile/UserProfile.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';

late KiwiContainer app;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebasePerformance _performance = FirebasePerformance.instance;
FirebaseAnalytics analytics = FirebaseAnalytics();
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  app = KiwiContainer();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) async {
    setup();

    await app.resolve<PrefUtils>().init();
    setupFCM();

    runApp(SettingsModelsProvider(
      child: GlobalModelsProvider(
        child: StreamBuilder<String>(
            stream: ThemeHelper.appthemeString,
            builder: (context, snapshot) {
              return StreamBuilder(
                // stream: LanguageManager.languageCodeStream,
                builder: (context, snapshot2) {
                  return Base();
                },
              );
            }),
      ),
    ));
  });
}

Future<void> setupFCM() async {
  await Firebase.initializeApp();
  analytics.setAnalyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  _performance.setPerformanceCollectionEnabled(true);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    showNotification(event.notification);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    openNotification(message);
    print('Message clicked!');
  });

  _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);

  var token = app
      .resolve<PrefUtils>()
      .getString(app.resolve<PrefUtils>().keyIsFCMToken);
  if (token.length == 0) {
    print("sdfsdf");
    _firebaseMessaging.getToken().then((token) {
      if (token != null) {
        app
            .resolve<PrefUtils>()
            .saveString(app.resolve<PrefUtils>().keyIsFCMToken, token);
      }
    });
  }

  configLocalNotification();
}

void configLocalNotification() {
  var initializationSettingsAndroid =
      new AndroidInitializationSettings("@mipmap/launcher_icon");
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
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

GlobalKey navigationKey = GlobalKey();

class Base extends StatefulWidget {
  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  late ThemeData themeData;

  @override
  void initState() {
    super.initState();
    ThemeHelper.changeTheme("light");

    WidgetsBinding.instance?.addPostFrameCallback(
      (_) => setState(() {
        themeData = AppTheme.of(context).theme;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    app.resolve<PrefUtils>().saveDeviceId();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: LanguageProvider(),
        ),
        ChangeNotifierProvider.value(
          value: MatchingProfileProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ReportAndBlockProvider(),
        ),
        ChangeNotifierProvider.value(
          value: FollowesProvider(),
        ),
        ChangeNotifierProvider.value(
          value: FeedBackProvider(),
        ),
        ChangeNotifierProvider.value(
          value: DiscoverProvider(),
        ),
        ChangeNotifierProvider.value(
          value: TagsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: VideoCallStatusProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PaymentHistoryProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ChatProvider(),
        ),
        ChangeNotifierProvider.value(
          value: VisitorProvider(),
        ),
        ChangeNotifierProvider.value(
          value: FavouriteProvider(),
        ),
        ChangeNotifierProvider.value(
          value: GiftProvider(),
        ),
        ChangeNotifierProvider.value(
          value: WithDrawProvider(),
        ),
      ],
      child: MaterialApp(
        key: navigationKey,
        debugShowCheckedModeBanner: false,
        title: APPNAME,
        navigatorKey: NavigationUtilities.key,
        onGenerateRoute: onGenerateRoute,
        navigatorObservers: [routeObserver, observer],
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: appTheme?.colorPrimary,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          fontFamily: 'Montserrat',
        ),
        home: Splash(),
        // routes: <String, WidgetBuilder>{
        //   '/ThemeSetting': (BuildContext context) => ThemeSetting(),
        // },
        builder: _builder,
      ),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    return Column(
      children: <Widget>[
        Expanded(child: child ?? Container()),
      ],
    );
  }
}
