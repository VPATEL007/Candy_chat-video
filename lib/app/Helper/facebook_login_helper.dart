import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';

class FacebookLoginHelper {
  static var shared = FacebookLoginHelper();

  loginWithFacebook(
      BuildContext context, Map<String, dynamic> req, Function callback) async {
    if (kDebugMode) {
      //For Simulator Testing

      req["provider"] = faceBook;
      req["token"] =
          "EAADVUNhhBzUBAGOprGMRITg1PFhzY3NjZCZAJZCHQl7DwJ3oUBpu8gZAvZC032VZBLPzaNUynQ5ZBGbkNW7RnocaO0iwZAIiLz5RcAtoVZBhIi4IcMxj8BsbhETOedSScQ7lgNgcnUAwXzrRgwFC2Wa8Qq5ifNsS7QZCCrXyiuOCmh1ICpW1Ho2WSqeb9Afa403SClAt90hd4wPHOuZBJA9aDrbLMHYPoBMsAiU64USX1gRI2SfCF5OZArs6";
      CommonApiHelper.shared.callLoginApi(req, context, () {}, () {});
    } else {
      try {
        AccessToken accessToken = await FacebookAuth.instance
            .login(); // by the fault we request the email and the public profile

        final userData = await FacebookAuth.instance.getUserData();

        req["provider"] = faceBook;
        req["token"] = accessToken.token;

        CommonApiHelper.shared.callLoginApi(req, context, () {}, () {});
      } on FacebookAuthException catch (e) {
        switch (e.errorCode) {
          case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
            print("You have a previous login operation in progress");
            break;
          case FacebookAuthErrorCode.CANCELLED:
            print("login cancelled");
            break;
          case FacebookAuthErrorCode.FAILED:
            print("login failed");
            break;
        }
      } catch (e, s) {
        print(e);
        print(s);
      } finally {}
    }
  }

  logout() async {
    await FacebookAuth.instance.logOut();
  }
}
