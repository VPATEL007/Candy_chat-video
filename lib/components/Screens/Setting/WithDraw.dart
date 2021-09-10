import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/provider/followes_provider.dart';

class WithDraw extends StatefulWidget {
  WithDraw({Key key}) : super(key: key);

  @override
  _WithDrawState createState() => _WithDrawState();
}

class _WithDrawState extends State<WithDraw> {
  TextEditingController coinsController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String paymentType;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(context, "Withdraw",
          isWhite: true, leadingButton: getBackButton(context)),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: getBottomButton(context, "Submit", () {
          if (isValid()) {
            callApiForWithdraw();
          }
        }),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(left: getSize(16), right: getSize(16)),
        child: Container(
          width: MathUtilities.screenWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: getSize(20),
              ),
              Center(
                child: Text(
                  Provider.of<FollowesProvider>(context, listen: false)
                          .userModel
                          ?.coinBalance
                          ?.toStringAsFixed(0) ??
                      "",
                  style: appTheme.black16Bold.copyWith(
                      fontSize: getFontSize(80), color: ColorConstants.redText),
                ),
              ),
              SizedBox(
                height: getSize(12),
              ),
              Center(
                child: Text(
                  "Total Coin Balance",
                  style: appTheme.black16Medium,
                ),
              ),
              SizedBox(
                height: getSize(20),
              ),
              Text(
                "Coins",
                style: appTheme.black16Medium,
              ),
              SizedBox(
                height: getSize(12),
              ),
              CommonTextfield(
                textOption: TextFieldOption(
                    keyboardType: TextInputType.phone,
                    hintText: "Coins",
                    inputController: coinsController),
                textCallback: (text) {},
              ),
              SizedBox(
                height: getSize(12),
              ),
              Text(
                "Payment types",
                style: appTheme.black16Medium,
              ),
              SizedBox(
                height: getSize(12),
              ),
              Container(
                width: MathUtilities.screenWidth(context) - getSize(32),
                decoration: BoxDecoration(
                    color: fromHex("#F6F6F6"),
                    borderRadius:
                        BorderRadius.all(Radius.circular(getSize(10)))),
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: DropdownButton<String>(
                    value: paymentType,
                    hint: Padding(
                      padding: EdgeInsets.all(getSize(16)),
                      child: Text("Select Payment Type"),
                    ),
                    iconSize: 0,
                    elevation: 16,
                    style: appTheme.black14Normal,
                    underline: Container(
                      height: 0,
                      color: Colors.white,
                    ),
                    onChanged: (String newValue) {
                      paymentType = newValue;
                      setState(() {});
                      if (newValue == "Paytm") {
                      } else {}
                    },
                    items: <String>['Paypal']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: getSize(12),
              ),
              paymentType == "Paytm"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mobile no",
                          style: appTheme.black16Medium,
                        ),
                        SizedBox(
                          height: getSize(12),
                        ),
                        CommonTextfield(
                          textOption: TextFieldOption(
                              keyboardType: TextInputType.phone,
                              hintText: "Mobile no",
                              inputController: mobileController),
                          textCallback: (text) {},
                        )
                      ],
                    )
                  : paymentType == "Paypal"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: appTheme.black16Medium,
                            ),
                            SizedBox(
                              height: getSize(12),
                            ),
                            CommonTextfield(
                              textOption: TextFieldOption(
                                  hintText: "Email",
                                  inputController: emailController),
                              textCallback: (text) {},
                            )
                          ],
                        )
                      : SizedBox()
            ],
          ),
        ),
      )),
    );
  }

  callApiForWithdraw() {
    Map<String, dynamic> req = {};
    req["coins"] = int.parse(coinsController.text);
    req["payment_method"] = 1;
    req["payment_id"] = emailController.text;

    NetworkClient.getInstance.showLoader(context);
    NetworkClient.getInstance.callApi(
      context: NavigationUtilities.key.currentState.overlay.context,
      params: req,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.withDrawRequest,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      successCallback: (response, message) async {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message, mode: DisplayMode.SUCCESS);
        await Provider.of<FollowesProvider>(context, listen: false)
            .fetchMyProfile(context);
        setState(() {});
      },
      failureCallback: (code, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
  }

  bool isValid() {
    FocusScope.of(context).unfocus();
    if (coinsController.text.isEmpty) {
      View.showMessage(context, "Please enter coins.");
      return false;
    }

    if (paymentType == null || paymentType?.length == 0) {
      View.showMessage(context, "Please select payment type.");
      return false;
    }

    if (paymentType == "Paypal" && emailController.text.isEmpty) {
      View.showMessage(context, "Please enter email.");
      return false;
    }

    if (paymentType == "Paypal" && !validateEmail(emailController.text)) {
      View.showMessage(context, "Please enter valid email.");
      return false;
    }

    if (paymentType == "Paytm" && mobileController.text.isEmpty) {
      View.showMessage(context, "Please enter mobile no.");
      return false;
    }

    if (paymentType == "Paytm" && !validateMobile(mobileController.text)) {
      View.showMessage(context, "Please enter valid mobile no.");
      return false;
    }

    return true;
  }
}
