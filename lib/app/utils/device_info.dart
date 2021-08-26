import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';


//Get Device Os Info...
Future<String> fetchDeviceOsInfo() async {
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      return '$release (SDK $sdkInt), $manufacturer $model';
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      return '$systemName $version, $name';
    }
  } catch (e) {
    print(e);
    return "";
  }
}
