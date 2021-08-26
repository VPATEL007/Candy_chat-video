import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/components/Screens/Splash/Splash.dart';
import 'package:video_chat/components/Screens/VideoCall/VideoCall.dart';
import 'package:video_chat/provider/discover_provider.dart';
import 'package:video_chat/provider/feedback_provider.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/language_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/payment_history.dart';
import 'package:video_chat/provider/report_and_block_provider.dart';
import 'package:video_chat/provider/tags_provider.dart';
import 'package:video_chat/provider/video_call_status_provider.dart';

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

import 'components/Screens/Profile/Coins.dart';

KiwiContainer app;

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
