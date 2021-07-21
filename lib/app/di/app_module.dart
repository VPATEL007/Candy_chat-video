import 'package:kiwi/kiwi.dart';

import 'package:video_chat/app/utils/flushbar_service.dart';

import '../app.export.dart';

part "app_module.g.dart";

abstract class AppModule {
  @Register.singleton(ConnectivityService)
  @Register.singleton(PrefUtils)
  @Register.singleton(FlushbarService)
  @Register.singleton(ThemeSettingsModel)
  void configure();
}

void setup() {
  var appModule = _$AppModule();
  appModule.configure();
}
