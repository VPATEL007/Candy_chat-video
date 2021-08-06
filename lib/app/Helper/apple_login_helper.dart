import 'package:apple_sign_in/apple_sign_in.dart';

class AppleLoginHealper {
  static var shared = AppleLoginHealper();

  login() async {
    revoked();
    if (await AppleSignIn.isAvailable()) {
      //Check if Apple SignIn isn available for the device or not
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
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
