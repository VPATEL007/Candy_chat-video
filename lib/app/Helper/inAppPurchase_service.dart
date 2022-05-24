import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/app/utils/navigator.dart';
import 'package:video_chat/app/utils/pref_utils.dart';
import 'package:video_chat/provider/followes_provider.dart';
import '../../main.dart';
import 'Themehelper.dart';

class InAppPurchaseHelper {
  InAppPurchaseHelper._();

  static InAppPurchaseHelper instance = InAppPurchaseHelper._();
  late StreamSubscription _purchaseUpdatedSubscription;
  late StreamSubscription _purchaseErrorSubscription;
  late StreamSubscription _conectionSubscription;

  List<String> _kProductIds = <String>[
    "com.randomvideochat.sugarcam.299",
    "com.randomvideochat.sugarcam.499",
    "com.randomvideochat.sugarcam.999",
    "com.randomvideochat.sugarcam.1499",
    "com.randomvideochat.sugarcam.2999",
    "com.randomvideochat.sugarcam.9999",
    "com.randomvideochat.sugarcam.24999"
  ];

  List<IAPItem> listProducts = [];

//Get Product
  Future<List<IAPItem>> getProducts() async {
    await intialConfig();

    NetworkClient.getInstance
        .showLoader(NavigationUtilities.key.currentContext!);
    try {
      List<IAPItem> items =
          await FlutterInappPurchase.instance.getProducts(_kProductIds);
      if (items != null) {
        items.sort((a, b) {
          return double.parse(a.price ?? "0")
              .compareTo(double.parse(b.price ?? "0"));
        });
        listProducts = items;
      }
    } catch (e) {
      print(e.toString());
    }

    NetworkClient.getInstance.hideProgressDialog();
    return listProducts;
  }

  intialConfig() async {
    try {
      await FlutterInappPurchase.instance.platformVersion;
    } on PlatformException {
      print("sdfsdf");
    }

    await FlutterInappPurchase.instance.initConnection;

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      print('purchase-updated: $productItem');
      if (productItem != null) {
        verifyPurchase(productItem, NavigationUtilities.key.currentContext!);
      }
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    });
  }

  //Purchase
  purchaseProduct(IAPItem product) {
    FlutterInappPurchase.instance.requestPurchase(product.productId ?? "");
  }

//Verify Purchase
  Future<bool> verifyPurchase(
      PurchasedItem purchaseDetails, BuildContext context) async {
    if (Platform.isAndroid) {
      // await FlutterInappPurchase.instance.validateReceiptAndroid(
      //     packageName: "com.randomvideochat.sugarcam",
      //     productId: purchaseDetails.productId ?? "",
      //     productToken: purchaseDetails.purchaseToken ?? "",
      //     accessToken: accessToken);
      creditCoin(purchaseDetails);
      return Future<bool>.value(true);
    }
    var isSuccess = false;
    Map<String, dynamic> req = {};

    req["receipt-data"] = purchaseDetails.transactionReceipt;

    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.inAppVerfiySandBoxURL,
      command: "",
      params: req,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      successCallback: (response, message) async {
        creditCoin(purchaseDetails);
        isSuccess = true;
      },
      failureCallback: (code, message) {
        View.showMessage(context, message);
        isSuccess = false;
      },
    );

    return isSuccess;
  }

//Credit Coin
  creditCoin(PurchasedItem purchaseDetails) async {
    var product = listProducts.firstWhere(
        (element) => element.productId == purchaseDetails.productId);

    Map<String, dynamic> req = {};
    if (Platform.isAndroid) {
      req["gateway"] = "android";
      req["purchaseToken"] = purchaseDetails.purchaseToken;
    } else {
      req["gateway"] = "apple";
    }

    req["package_id"] = purchaseDetails.productId;
    req["transaction_id"] = purchaseDetails.transactionId;
    req["package_name"] = "com.randomvideochat.sugarcam";
    req["paid_amount"] = product.price;
    req["currency"] = product.currency;
    req["user_id"] = app.resolve<PrefUtils>().getUserDetails()?.id.toString();

    await NetworkClient.getInstance.callApi(
      context: NavigationUtilities.key.currentContext!,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.buyPackage,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: req,
      successCallback: (response, message) async {
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
        View.showMessage(NavigationUtilities.key.currentContext!, message);
      },
    );
  }

  openCoinPurchasePopUp() async {
    var _products = await InAppPurchaseHelper.instance.getProducts();
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: NavigationUtilities.key.currentContext!,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                    top: getSize(23), left: getSize(26), right: getSize(26)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Insufficient Coins",
                          style: appTheme?.black16Bold
                              .copyWith(fontSize: getFontSize(25)),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Close",
                            style: appTheme?.black14SemiBold.copyWith(
                                fontSize: getFontSize(18),
                                color: ColorConstants.red),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: getSize(19),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          icCoin,
                          height: getSize(20),
                        ),
                        SizedBox(
                          width: getSize(8),
                        ),
                        Text(
                          "30/min",
                          style: appTheme?.black12Normal.copyWith(
                              fontSize: getFontSize(18),
                              color: ColorConstants.red),
                        )
                      ],
                    ),
                    SizedBox(
                      height: getSize(13),
                    ),
                    Text(
                      "Recharge to enable 1 to 1 Video chat.",
                      style: appTheme?.black14Normal
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: getSize(26),
                    ),
                    GridView.builder(
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _products.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {
                                InAppPurchaseHelper.instance
                                    .purchaseProduct(_products[index]);
                              },
                              child: getCoinItem(
                                  _products[index], false, context));
                          // return getCoinItem(index == 0, context);
                        }),
                    SizedBox(
                      height: getSize(22),
                    ),
                    getPopBottomButton(context, "Apply", () {})
                  ],
                ),
              ));
            },
          );
        });
  }
}
