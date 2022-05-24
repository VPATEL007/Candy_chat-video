import 'package:appsflyer_sdk/appsflyer_sdk.dart';

import 'apps_flyer_keys.dart';

class AppsFlyerService {
  static late AppsFlyerService appsFlyerService;
  static late AppsflyerSdk _appsflyerSdk;

  final String eventName = "my event";

  static Future<AppsFlyerService> getInstance() async {
    var appsFlyer = AppsFlyerService._();
    await appsFlyer._init();
    appsFlyerService = appsFlyer;
    print('app flyer initialised');
    return appsFlyerService;
  }

  AppsFlyerService._();

  Future _init() async {
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: AppsFlyerKeys.afDevKey,
        appId: AppsFlyerKeys.appId,
        showDebug: true,
        timeToWaitForATTUserAuthorization: 15);
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.initSdk();
    _appsflyerSdk.onAppOpenAttribution((res) {
      print("onAppOpenAttribution res: " + res.toString());
    });
    _appsflyerSdk.onInstallConversionData((res) {
      print("onInstallConversionData res: " + res.toString());
    });
  }

  logData(eventName, eventValues) {
    logEvent(eventName, eventValues).then((onValue) {
      print('_logEventResponse==> $onValue');
    }).catchError((onError) {
      print('_logEventResponse==> $onError');
    });
  }

  Future<bool?> logEvent(String eventName, Map eventValues) {
    return _appsflyerSdk.logEvent(eventName, eventValues);
  }
}
