import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/modules.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/inAppPurchase_service.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/provider/followes_provider.dart';

class Coins extends StatefulWidget {
  const Coins({Key? key}) : super(key: key);

  @override
  _CoinsState createState() => _CoinsState();
}

class _CoinsState extends State<Coins> {
  InAppPurchaseHelper purchase = InAppPurchaseHelper.instance;

  // List<ProductDetails> _products = [];
  List<IAPItem> _products = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getList();
    });
  }

  getList() async {
    _products = await purchase.getProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Column(
          children: [
            getNaviagtion(),
            SizedBox(
              height: getSize(20),
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  shrinkWrap: true,
                  itemCount: _products.length,
                  padding:
                      EdgeInsets.only(left: getSize(28), right: getSize(28)),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          purchase.purchaseProduct(_products[index]);
                        },
                        child: getCoinItem(_products[index], false, context));
                  }),
            ),
          ],
        )));
  }

  getNaviagtion() {
    return Row(
      children: [
        getBackButton(context),
        Spacer(),
        getColorText("Get", Colors.black),
        SizedBox(
          width: getSize(6),
        ),
        getColorText("Coins", ColorConstants.red),
        Spacer(),
        // InkWell(
        //     onTap: () {
        //       creditCoin();
        //     },
        //     child: Text("Add Coins")),
        // SizedBox(
        //   width: 20,
        // )
      ],
    );
  }

  creditCoin() {
    Map<String, dynamic> req = {};
    req["gateway"] = "apple";
    req["package_id"] = "com.randomvideochat.videochat.299";
    req["transaction_id"] = "12346579";
    req["package_name"] = "30 Coins ";
    req["paid_amount"] = 89.0;
    req["currency"] = "INR";
    req["user_id"] = app.resolve<PrefUtils>().getUserDetails()?.id.toString();

    NetworkClient.getInstance
        .showLoader(NavigationUtilities.key.currentContext!);
    NetworkClient.getInstance.callApi(
      context: NavigationUtilities.key.currentContext!,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.buyPackage,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: req,
      successCallback: (response, message) async {
        NetworkClient.getInstance.hideProgressDialog();

        Provider.of<FollowesProvider>(
                NavigationUtilities.key.currentState!.overlay!.context,
                listen: false)
            .fetchMyProfile(
                NavigationUtilities.key.currentState!.overlay!.context);
        View.showMessage(NavigationUtilities.key.currentContext!,
            "Your coin credited in your account.",
            mode: DisplayMode.SUCCESS);
      },
      failureCallback: (code, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(NavigationUtilities.key.currentContext!, message);
      },
    );
  }
}
