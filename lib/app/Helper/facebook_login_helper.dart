import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';

class FacebookLoginHelper {
  static var shared = FacebookLoginHelper();

  loginWithFacebook(
      BuildContext context, Map<String, dynamic> req, Function callback) async {
    try {
      LoginResult loginresult = await FacebookAuth.instance
          .login(); // by the fault we request the email and the public profile

      if (loginresult.accessToken != null) {
        req["provider"] = faceBook;
        req["token"] = loginresult.accessToken?.token;

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
