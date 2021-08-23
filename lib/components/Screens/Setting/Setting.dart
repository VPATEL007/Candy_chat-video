import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/theme/app_theme.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Screens/Setting/BlockList.dart';
import 'package:video_chat/components/Screens/Setting/FavouriteList.dart';
import 'package:video_chat/components/Screens/Setting/feedback.dart';

class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  RateMyApp rateMyApp = RateMyApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBar(context, "Settings",
            isWhite: true, leadingButton: getBackButton(context)),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.only(
              left: getSize(30), right: getSize(30), top: getSize(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                getListItem("Favourite", () {
                  NavigationUtilities.push(FavouriteList());
                }),
                getListItem("Blocked List", () {
                  NavigationUtilities.push(BlockList());
                }),
                getListItem("Rate Us", () {
                  rateMyApp.showStarRateDialog(
                    context,
                    title: 'Rate this app', // The dialog title.
                    message:
                        'You like this app ? Then take a little bit of your time to leave a rating :', // The dialog message.
                    // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
                    actionsBuilder: (context, stars) {
                      // Triggered when the user updates the star rating.
                      return [
                        // Return a list of actions (that will be shown at the bottom of the dialog).
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () async {
                            print('Thanks for the ' +
                                (stars == null
                                    ? '0'
                                    : stars.round().toString()) +
                                ' star(s) !');
                            // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                            // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                            await rateMyApp.callEvent(
                                RateMyAppEventType.rateButtonPressed);
                            Navigator.pop<RateMyAppDialogButton>(
                                context, RateMyAppDialogButton.rate);
                          },
                        ),
                      ];
                    },
                    ignoreNativeDialog: false,
                    dialogStyle: const DialogStyle(
                      // Custom dialog styles.
                      titleAlign: TextAlign.center,
                      messageAlign: TextAlign.center,
                      messagePadding: EdgeInsets.only(bottom: 20),
                    ),
                    starRatingOptions:
                        const StarRatingOptions(), // Custom star bar rating options.
                    onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
                        .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
                  );
                }),
                getListItem("Privacy Policy", () {}),
                getListItem("Feedback", () {
                  NavigationUtilities.push(FeedbackScreen());
                }),
                getListItem("About Us", () {})
              ],
            ),
          ),
        )));
  }

  getListItem(String text, Function click) {
    return InkWell(
      onTap: () {
        click();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: getSize(21)),
        child: Container(
          width: MathUtilities.screenWidth(context),
          decoration: BoxDecoration(
            color: fromHex("#F6F6F6"),
            borderRadius: BorderRadius.circular(
              getSize(10),
            ),
          ),
          child: Padding(
              padding: EdgeInsets.all(getSize(22)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: appTheme.black14Normal
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Image.asset(
                    icDetail,
                    height: getSize(18),
                    width: getSize(18),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
