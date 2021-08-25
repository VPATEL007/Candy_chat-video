import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';

class GoogleSignInHelper with ChangeNotifier {
  GoogleSignInHelper._();
  static GoogleSignInHelper instance = GoogleSignInHelper._();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  Future<void> handleSignIn(BuildContext context,Map<String, dynamic> req) async {
    try {
      GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await signInAccount.authentication;

      req["provider"] = google;
      req["token"] = googleSignInAuthentication.accessToken;

      CommonApiHelper.shared.callLoginApi(req, context, () {}, () {});
    } on PlatformException catch (error) {
      print(error);
      View.showMessage(context, error.message.toString());
    }catch (error) {
      print(error);
      View.showMessage(context, error.toString());
    }
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();
}
