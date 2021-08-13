import 'package:flutter/material.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Language/Language.dart';

class LanguageProvider with ChangeNotifier {
  List<LanguageModel> _arrList = [];

  set selctedLanguage(LanguageModel language) {
    app.resolve<PrefUtils>().selectedLanguage = language;
    notifyListeners();
  }

  LanguageModel get selctedLanguage =>
      app.resolve<PrefUtils>().selectedLanguage;

  set arrList(List<LanguageModel> language) {
    _arrList = language;
    notifyListeners();
  }

  List<LanguageModel> get arrList => _arrList;

  // Fetch language list...
  Future<void> fetchLanguageList(
      BuildContext context, bool isBackgroundFetch) async {
    await CommonApiHelper.shared.callLanguageListApi(context, (list) {
      arrList = list;
      if (selctedLanguage == null) selctedLanguage = arrList.first;
    }, () {}, isBackgroundFetch);
  }
}
