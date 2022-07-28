import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';

import '../utils/apps_flyer/apps_flyer_keys.dart';
import '../utils/apps_flyer/apps_flyer_service.dart';

class FacebookLoginHelper {
  static var shared = FacebookLoginHelper();

  loginWithFacebook(
      BuildContext context, Map<String, dynamic> req, Function callback) async {
    try {
      LoginResult loginresult = await FacebookAuth.instance
          .login(); // by the fault we request the email and the public profile

      if (loginresult.accessToken != null) {
        req["provider"] = faceBook;
        req["registerApp"] = 'host';
        req["token"] = loginresult.accessToken?.token;
        final Map eventValues = {"af_registration_type": "facebook"};
        AppsFlyerService.appsFlyerService
            .logData(AppsFlyerKeys.registration, eventValues);
        CommonApiHelper.shared.callLoginApi(req, context, () {}, () {});
      }
    } catch (e, s) {
      View.showMessage(context, e.toString());
    } finally {}
  }

  logout() async {
    await FacebookAuth.instance.logOut();
  }
}
