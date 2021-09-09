import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
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
import 'package:firebase_core/firebase_core.dart';

import 'app/Helper/Themehelper.dart';
import 'app/constant/constants.dart';
import 'app/di/app_module.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/global_models_provider.dart';
import 'app/theme/settings_models_provider.dart';
import 'app/utils/navigator.dart';
import 'app/utils/pref_utils.dart';
import 'app/utils/route_observer.dart';
import 'package:video_chat/modules/ThemeSetting.dart';
import 'package:http_proxy/http_proxy.dart';

KiwiContainer app;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  app = KiwiContainer();

  if (kDebugMode) {
    HttpProxy httpProxy = await HttpProxy.createHttpProxy();
    HttpOverrides.global = httpProxy;
  }

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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _firebaseMessaging.configure(
    //onBackgroundMessage: _firebaseMessagingBackgroundHandler,
    onMessage: (Map<String, dynamic> message) async {
      print("onMessageASDASD: $message");
      showNotification(message);
      // onNotificationReceived(message, context);
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");

      Future.delayed(const Duration(seconds: 3), () {
        // onNotificationReceived(message, context);
      });
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      // onNotificationReceived(message, context);
    },
  );

  //Needed by iOS only
  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });

  var token = app
      .resolve<PrefUtils>()
      .getString(app.resolve<PrefUtils>().keyIsFCMToken);
  if (token.length == 0) {
    print("sdfsdf");
    //Getting the token from FCM
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      print('------------------------');
      print('token: $token');
      app
          .resolve<PrefUtils>()
          .saveString(app.resolve<PrefUtils>().keyIsFCMToken, token);
      print('------------------------');
      // UserPreferences().saveToken(token);
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

void showNotification(message) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    Platform.isAndroid
        ? 'high_importance_channel'
        : 'com.randomvideochat.videochat',
    'This channel is used for important notifications.',
    '',
    playSound: true,
    enableVibration: true,
    importance: Importance.max,
    priority: Priority.high,
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'].toString(),
      message['notification']['body'].toString(),
      platformChannelSpecifics,
      payload: json.encode(message));
}

GlobalKey navigationKey = GlobalKey();

class Base extends StatefulWidget {
  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  ThemeData themeData;

  @override
  void initState() {
    super.initState();
    ThemeHelper.changeTheme("light");

    WidgetsBinding.instance.addPostFrameCallback(
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
      ],
      child: MaterialApp(
        key: navigationKey,
        debugShowCheckedModeBanner: false,
        title: APPNAME,
        navigatorKey: NavigationUtilities.key,
        onGenerateRoute: onGenerateRoute,
        navigatorObservers: [
          routeObserver,
        ],
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: appTheme.colorPrimary,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          fontFamily: 'Montserrat',
        ),
        home: Splash(),
        routes: <String, WidgetBuilder>{
          '/ThemeSetting': (BuildContext context) => ThemeSetting(),
        },
        builder: _builder,
      ),
    );
  }

  Widget _builder(BuildContext context, Widget child) {
    return Column(
      children: <Widget>[
        Expanded(child: child),
      ],
    );
  }
}
