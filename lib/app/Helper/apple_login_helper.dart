import 'package:flutter/cupertino.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:video_chat/app/app.export.dart';

import 'CommonApiHelper.dart';

class AppleLoginHealper {
  static var shared = AppleLoginHealper();

  login(
      BuildContext context, Map<String, dynamic> req, Function callback) async {
    revoked();
    SignInWithApple.getCredentialState("");
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (credential.identityToken != null) {
      req["provider"] = apple;
      req["language_id"] = app.resolve<PrefUtils>().selectedLanguages?.id;
      req["token"] = credential.identityToken;
      req["registerApp"] = 'host';
      Map<String, dynamic> user = {};
      user["name"] = credential.familyName;
      user["email"] = credential.email;
      user["uid"] = credential.userIdentifier;
      req["userData"] = user;
      CommonApiHelper.shared.callLoginApi(req, context, () {}, () {});
    }

    // if (await AppleSignIn.isAvailable()) {
    //   //Check if Apple SignIn isn available for the device or not
    //   final AuthorizationResult result = await AppleSignIn.performRequests([
    //     AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    //   ]);

    // req["provider"] = apple;
    // req["language_id"] = app.resolve<PrefUtils>().selectedLanguages?.id;

    //   req["token"] = String.fromCharCodes(result.credential.identityToken);
    // Map<String, dynamic> user = {};
    //   user["name"] = (result.credential.fullName.familyName ?? "") +
    //       (result.credential.fullName.givenName ?? "");
    //   user["email"] = result.credential.email;
    //   user["uid"] = result.credential.user;
    //   req["userData"] = user;
    //   CommonApiHelper.shared.callLoginApi(req, context, () {}, () {});
    // switch (result.status) {
    //   case AuthorizationStatus.authorized:
    //     print(result.credential.user); //All the required credentials
    //     break;
    //   case AuthorizationStatus.error:
    //     print("Sign in failed: ${result.error.localizedDescription}");
    //     break;
    //   case AuthorizationStatus.cancelled:
    //     print('User cancelled');
    //     break;
    // }
    // } else {
    //   View.showMessage(
    //       context, 'Apple SignIn is not available for your device');
    //   print('Apple SignIn is not available for your device');
    //   // callback("Apple SignIn is not available for your device");
    // }
  }

  void revoked() {
    //Revoked
    // AppleSignIn.onCredentialRevoked.listen((_) {
    //   print("Credentials revoked");
    // });
  }
}
