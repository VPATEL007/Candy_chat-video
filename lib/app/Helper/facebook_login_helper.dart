import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginHelper {
  static var shared = FacebookLoginHelper();

  loginWithFacebook(Function callback) async {
    try {
      AccessToken accessToken = await FacebookAuth.instance
          .login(); // by the fault we request the email and the public profile

      final userData = await FacebookAuth.instance.getUserData();
      print(userData);
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

  logout() async {
    await FacebookAuth.instance.logOut();
  }
}
