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
          "EAADVUNhhBzUBAD7RS8qCTSaCLQbBZCV2bkILSREAFZC6KpfYxQh6iDTvzojhxuZBJw3a5UXFNS4l4ARxOsW80ESr8NlsUyXlWTERTQYTBsGzrrUkFLcp36sjZAxQfgMK3wFVkhyIwJ4lfsK8TqiEzAhzt3QOpTtvRZAfdde0BRe8DiWZAFzfFbDeSDzgVGaJ9r75YFaW0vVSDZCjYCZBM3RihAf0KhRTEAysZAOARZAOg0A0e77fG0eccDTI78T3oZBv5YZD";
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
