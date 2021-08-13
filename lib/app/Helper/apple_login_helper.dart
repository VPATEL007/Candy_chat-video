import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/provider/language_provider.dart';

import 'CommonApiHelper.dart';

class AppleLoginHealper {
  static var shared = AppleLoginHealper();

  login(BuildContext context, Function callback) async {
    revoked();
    if (await AppleSignIn.isAvailable()) {
      //Check if Apple SignIn isn available for the device or not
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      Map<String, dynamic> req = {};
      req["provider"] = apple;
      req["language_id"] = app.resolve<PrefUtils>().selectedLanguage.id;

      req["token"] = result.credential.user;
      Map<String, dynamic> user = {};
      user["name"] = (result.credential.fullName.familyName ?? "") +
          (result.credential.fullName.givenName ?? "");
      user["email"] = result.credential.email;
      user["uid"] = String.fromCharCodes(result.credential.identityToken);
      req["userData"] = user;
      CommonApiHelper.shared.callLoginApi(req, context, () {}, () {});
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential.user); //All the required credentials
          break;
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    } else {
      View.showMessage(
          context, 'Apple SignIn is not available for your device');
      print('Apple SignIn is not available for your device');
      // callback("Apple SignIn is not available for your device");
    }
  }

  void revoked() {
    //Revoked
    AppleSignIn.onCredentialRevoked.listen((_) {
      print("Credentials revoked");
    });
  }
}
