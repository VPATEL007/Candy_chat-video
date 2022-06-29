import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Language/Language.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';

/// Wraps the [SharedPreferences].
class PrefUtils {
  // static final Logger _log = Logger("Prefs");

  String? deviceId;

  SharedPreferences? _preferences;

  String get keySelectedThemeId => "my_app_SelectedThemeId";
  String get keyPlayerID => "playerId";
  String get keyIsShowThemeSelection => "keyIsShowThemeSelection";
  String get keyUserDetail => "keyUserDetail";
  String get keyToken => "keyToken";
  String get keyRefereshToken => "keyRefereshToken";
  String get keyIsUserLogin => "keyIsUserLogin";
  String get keyIsShowIntro => "keyIsShowIntro";
  String get keySelectLang => "selected_lang";
  String get keyIsFCMToken => "keyIsFCMToken";
  String get keyIsFromAge => "keyFromAge";
  String get keyIsToAge => "keyToAge";
  String get callerName=> 'username';

  bool? isHomeVisible;

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  /// Gets the int value for the [key] if it exists.
  int getInt(String key, {int defaultValue = 0}) {
    try {
      init();
      return _preferences?.getInt(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Gets the bool value for the [key] if it exists.
  bool getBool(String key, {bool defaultValue = false}) {
    try {
      init();
      return _preferences?.getBool(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Gets the String value for the [key] if it exists.
  String getString(String key, {String defaultValue = ""}) {
    try {
      init();
      return _preferences?.getString(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Gets the string list for the [key] or an empty list if it doesn't exist.
  List<String> getStringList(String key) {
    try {
      init();
      return _preferences?.getStringList(key) ?? <String>[];
    } catch (e) {
      return <String>[];
    }
  }

  /// Gets the int value for the [key] if it exists.
  void saveInt(String key, int value) {
    init();
    _preferences?.setInt(key, value);
  }

  Future<void> saveDeviceId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        deviceId = androidInfo.androidId;
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        deviceId = iosInfo.identifierForVendor;
      }
    } catch (e) {}
  }

  /// Gets the int value for the [key] if it exists.
  void saveBoolean(String key, bool value) {
    init();
    _preferences?.setBool(key, value);
  }

  /// Gets the int value for the [key] if it exists.
  void saveString(String key, String value) {
    init();
    _preferences?.setString(key, value);
  }

  /// Gets the string list for the [key] or an empty list if it doesn't exist.
  void saveStringList(String key, List<String> value) {
    init();
    _preferences?.setStringList(key, value);
  }

  void saveShowThemeSelection(bool showThemeSelection) {
    _preferences?.setBool(keyIsShowThemeSelection, showThemeSelection);
  }

//TO CHECK WEATHER USER LOGIN OR NOT
  bool isUserLogin() {
    //  return  _preferences.getBool(keyIsUserLogin) ?? false;
    return getBool(keyIsUserLogin);
  }

  bool isShowIntro() {
    return getBool(keyIsShowIntro);
  }

  // User Getter setter
  void saveUser(UserModel user, {bool isLoggedIn = false}) {
    if (isLoggedIn == true) {
      _preferences?.setBool(keyIsUserLogin, true);
    }

    _preferences?.setString(keyUserDetail, json.encode(user));
  }

  UserModel? getUserDetails() {
    var userJson = json.decode(_preferences?.getString(keyUserDetail) ?? "");
    return userJson != null ? new UserModel.fromJson(userJson) : null;
  }

  //get Token
  String getUserToken({bool isRefereshToken = false}) {
    if (isRefereshToken) {
      return _preferences?.getString(keyRefereshToken) ?? "";
    }
    return _preferences?.getString(keyToken) ?? "";
  }

  Future<void> saveUserToken(String token) async {
    await _preferences?.setString(keyToken, token);
  }

  void saveRefereshToken(String token) {
    _preferences?.setString(keyRefereshToken, token);
  }

  LanguageModel? _selectedLanguage;

  set selectedLanguage(LanguageModel languageModel) {
    _preferences?.setString(keySelectLang, languageModelToJson(languageModel));
    _selectedLanguage = languageModel;
  }

  LanguageModel? get selectedLanguages {
    _selectedLanguage = (_preferences?.getString(keySelectLang)?.isEmpty ??
            true)
        ? null
        : languageModelFromJson(_preferences?.getString(keySelectLang) ?? "");

    return _selectedLanguage;
  }

  void clearPreferenceAndDB() async {
    _preferences?.clear();

    // await AppDatabase.instance.masterDao.deleteAllMasterItems();

    // await CacheManager.getInstance().deleteFolderExist('/storage');
  }

  resetAndLogout(BuildContext context) {
    // clear all data and Preferences
    app.resolve<PrefUtils>().clearPreferenceAndDB();

    // Navigator.of(NavigationUtilities.key.currentState.overlay.context)
    //     .pushNamedAndRemoveUntil(
    //   LoginScreen.route,
    //   (Route<dynamic> route) => false,
    // );
  }
}
