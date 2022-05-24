import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';

import '../utils/apps_flyer/apps_flyer_keys.dart';
import '../utils/apps_flyer/apps_flyer_service.dart';

class GoogleSignInHelper with ChangeNotifier {
  GoogleSignInHelper._();
  static GoogleSignInHelper instance = GoogleSignInHelper._();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> handleSignIn(
      BuildContext context, Map<String, dynamic> req) async {
    try {
      GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
      if (signInAccount == null) return;
      GoogleSignInAuthentication? googleSignInAuthentication =
          await signInAccount.authentication;

      req["provider"] = google;
      req["token"] = googleSignInAuthentication.accessToken;

      CommonApiHelper.shared.callLoginApi(req, context, () {}, () {});
      final Map eventValues = {
        "af_email": "${signInAccount.email}",
        "af_registration_type": "google"
      };
      AppsFlyerService.appsFlyerService
          .logData(AppsFlyerKeys.registration, eventValues);
    } on PlatformException catch (error) {
      View.showMessage(context, error.message.toString());
    } catch (error) {
      print(error);
      // View.showMessage(context, error.toString());
    }
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();
}
