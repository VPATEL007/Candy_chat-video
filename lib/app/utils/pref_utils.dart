import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_chat/app/app.export.dart';

import 'package:unique_identifier/unique_identifier.dart';

/// Wraps the [SharedPreferences].
class PrefUtils {
  static final Logger _log = Logger("Prefs");

  String deviceId;

  SharedPreferences _preferences;

  /// The [prefix] is used in keys for user specific preferences. You can use unique user-id for multi_user
  // String get prefix => "my_app";
  String get keySelectedThemeId => "my_app_SelectedThemeId";

  String get keyPlayerID => "playerId";

  String get keyIsShowThemeSelection => "keyIsShowThemeSelection";

  String get keyUserDetail => "keyUserDetail";

  String get keyToken => "keyToken";

  String get keyIsUserLogin => "keyIsUserLogin";

  // String get keyDefaultLanguage => "keyDefaultLanguage";

  String get FILE_DEVIDE_INFO => "deviceDetail";

  bool isHomeVisible;

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  /// Gets the int value for the [key] if it exists.
  int getInt(String key, {int defaultValue = 0}) {
    try {
      init();
      return _preferences.getInt(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Gets the bool value for the [key] if it exists.
  bool getBool(String key, {bool defaultValue = false}) {
    try {
      init();
      return _preferences.getBool(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Gets the String value for the [key] if it exists.
  String getString(String key, {String defaultValue = ""}) {
    try {
      init();
      return _preferences.getString(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Gets the string list for the [key] or an empty list if it doesn't exist.
  List<String> getStringList(String key) {
    try {
      init();
      return _preferences.getStringList(key) ?? <String>[];
    } catch (e) {
      return <String>[];
    }
  }

  /// Gets the int value for the [key] if it exists.
  void saveInt(String key, int value) {
    init();
    _preferences.setInt(key, value);
  }

  Future<void> saveDeviceId() async {
    try {
      deviceId = await UniqueIdentifier.serial;
    } catch (e) {}
  }

  /// Gets the int value for the [key] if it exists.
  void saveBoolean(String key, bool value) {
    init();
    _preferences.setBool(key, value);
  }

  /// Gets the int value for the [key] if it exists.
  void saveString(String key, String value) {
    init();
    _preferences.setString(key, value);
  }

  /// Gets the string list for the [key] or an empty list if it doesn't exist.
  void saveStringList(String key, List<String> value) {
    init();
    _preferences.setStringList(key, value);
  }

  void saveShowThemeSelection(bool showThemeSelection) {
    _preferences.setBool(keyIsShowThemeSelection, showThemeSelection);
  }

//TO CHECK WEATHER USER LOGIN OR NOT
  bool isUserLogin() {
    //  return  _preferences.getBool(keyIsUserLogin) ?? false;
    return getBool(keyIsUserLogin) ?? false;
  }

  // User Getter setter
  // void saveUser(User user, {bool isLoggedIn = false}) {
  //   if (isLoggedIn == true) {
  //     _preferences.setBool(keyIsUserLogin, true);
  //   }

  //   _preferences.setString(keyUserDetail, json.encode(user));
  // }

  // User getUserDetails() {
  //   var userJson = json.decode(_preferences.getString(keyUserDetail));
  //   return userJson != null ? new User.fromJson(userJson) : null;
  // }

  //get Token
  String getUserToken() {
    // return getString(keyToken);
    return _preferences.getString(keyToken) ?? "";
  }

  void saveUserToken(String token) {
    _preferences.setString(keyToken, token);
  }

  // //Get default launague
  // String getDefaultLangauge() {
  //   return isNullEmptyOrFalse(getString(keyDefaultLanguage)) == true
  //       ? "en"
  //       : getString(keyDefaultLanguage);
  // }

  // //set default langauge
  // void setDefaultLangauge(String langaugeCode) {
  //   _preferences.setString(keyDefaultLanguage, langaugeCode);
  // }

  void clearPreferenceAndDB() async {
    _preferences.clear();

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
