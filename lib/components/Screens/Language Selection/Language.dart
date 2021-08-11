import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/AppConfiguration/AppNavigation.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/app/utils/navigator.dart';
import 'package:video_chat/app/utils/pref_utils.dart';
import 'package:video_chat/components/Model/Auth/OnboardingModel.dart';
import 'package:video_chat/components/Model/Language/Language.dart';
import 'package:video_chat/components/Screens/Onboarding/Onboarding.dart';

class LanguageSelection extends StatefulWidget {
  static const route = "LanguageSelection";
  bool isChange = false;

  LanguageSelection({Key key, this.isChange}) : super(key: key);

  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  LanguageModel selctedLanguage;
  List<LanguageModel> arrList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CommonApiHelper.shared.callLanguageListApi(context, (list) {
        arrList = list;
        selctedLanguage = arrList.first;
        setState(() {});
      }, () {});
    });
  }

  goToNext() {
    if (widget.isChange == null || widget.isChange == false) {
      getOnBoardingData();
    } else {
      Navigator.pop(context);
    }
  }

  getOnBoardingData() {
    if (!app.resolve<PrefUtils>().isShowIntro()) {
      NetworkClient.getInstance.showLoader(context);
      NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.onboarding,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) async {
          NetworkClient.getInstance.hideProgressDialog();
          List<dynamic> list = response;
          if (list != null) {
            List<OnboardingModel> arrList =
                list.map((obj) => OnboardingModel.fromJson(obj)).toList();

            NavigationUtilities.push(OnBoarding(
              list: arrList,
            ));
          }
        },
        failureCallback: (code, message) {
          NetworkClient.getInstance.hideProgressDialog();
        },
      );
    } else {
      AppNavigation.shared.goNextFromSplash();
    }
  }

  void referesh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorPrimary,
      bottomSheet: getBottomButton(context, "Next", () {
        goToNext();
      }),
      body: SafeArea(
        child: selctedLanguage == null
            ? SizedBox()
            : Container(
                width: MathUtilities.screenWidth(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.isChange == null
                        ? SizedBox()
                        : getBackButton(context),
                    SizedBox(
                      height: getSize(widget.isChange == null ? 20 : 0),
                    ),
                    Center(
                      child: getColorText(
                          widget.isChange == null ? "Select" : "Change",
                          ColorConstants.black,
                          fontSize: 35),
                    ),
                    SizedBox(
                      height: getSize(6),
                    ),
                    Center(
                      child: getColorText("Language", ColorConstants.red,
                          fontSize: 35),
                    ),
                    SizedBox(
                      height: getSize(35),
                    ),
                    Center(
                      child: Container(
                        width: getSize(200),
                        height: getSize(200),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 7,
                                spreadRadius: 5,
                                offset: Offset(0, 3)),
                          ],
                          border: Border.all(color: Colors.white, width: 4),
                          borderRadius: BorderRadius.circular(
                            getSize(210),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(getSize(210)),
                          child: getImageView(selctedLanguage.flagUrl,
                              height: getSize(200), width: getSize(200)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getSize(69),
                    ),
                    Center(
                      child: getColorText(
                          selctedLanguage.languageName, ColorConstants.black,
                          fontSize: 35),
                    ),
                    SizedBox(
                      height: getSize(30),
                    ),
                    Center(
                      child: Container(
                        height: getSize(100),
                        child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: arrList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return getLanguageItem(arrList[index]);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                width: getSize(16),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  getLanguageItem(LanguageModel model) {
    var height = model.id == selctedLanguage.id ? getSize(100) : getSize(62);
    var width = model.id == selctedLanguage.id ? getSize(100) : getSize(62);
    return InkWell(
      onTap: () {
        selctedLanguage = model;
        setState(() {});
      },
      child: Center(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: Offset(0, 3)),
            ],
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(
              getSize(62),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(getSize(62)),
            child: getImageView(model.flagUrl, height: height, width: width),
          ),
        ),
      ),
    );
  }
}
