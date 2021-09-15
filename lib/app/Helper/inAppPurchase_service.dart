import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/store_kit_wrappers.dart';
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
import 'dart:io' as io;

class InAppPurchase {
  InAppPurchase._();

  static InAppPurchase instance = InAppPurchase._();
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> subscription;
  List<String> _kProductIds = <String>[
    "com.randomvideochat.videochat.30",
    "com.randomvideochat.videochat.203"
  ];
  List<ProductDetails> listProducts = [];

//Get Product
  Future<List<ProductDetails>> getProducts() async {
    intialConfig();

    // final bool isAvailable = await _connection.isAvailable();
    // if (!isAvailable) {
    //   return [];
    // }

    List<ProductDetails> products = [];

    NetworkClient.getInstance
        .showLoader(NavigationUtilities.key.currentContext);
    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.productDetails != null) {
      products = productDetailResponse.productDetails;
      products.sort((a, b) {
        return a.rawPrice.compareTo(b.rawPrice);
      });
      listProducts = products;
    } else {
      products = [];
    }

    NetworkClient.getInstance.hideProgressDialog();
    completeTransaction();

    return products;
  }

  intialConfig() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    subscription = purchaseUpdated.listen((purchaseDetailsList) {
      listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

//Listen Purchase
  Future<void> listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
        await verifyPurchase(
            purchaseDetails, NavigationUtilities.key.currentContext);
        completeTransaction();
      }
    });
  }

  //Complete Transaction
  Future<void> completeTransaction() async {
    if (io.Platform.isIOS) {
      var transactions = await SKPaymentQueueWrapper().transactions();
      transactions.forEach((skPaymentTransactionWrapper) {
        SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
      });
    }
  }

  //Purchase
  purchaseProduct(ProductDetails product) {
    if (Platform.isAndroid) {
      PurchaseParam purchaseParam = PurchaseParam(
          productDetails: product,
          applicationUserName:
              app.resolve<PrefUtils>().getUserDetails().userName,
          changeSubscriptionParam: null);
      _connection.buyConsumable(
          purchaseParam: purchaseParam, autoConsume: true);
    } else {
      PurchaseParam purchaseParam = PurchaseParam(
          productDetails: product,
          applicationUserName:
              app.resolve<PrefUtils>().getUserDetails().userName,
          changeSubscriptionParam: null,
          sandboxTesting: false);
      _connection.buyConsumable(purchaseParam: purchaseParam);
    }
  }

//Verify Purchase
  Future<bool> verifyPurchase(
      PurchaseDetails purchaseDetails, BuildContext context) {
    if (Platform.isAndroid) {
      return Future<bool>.value(true);
    }

    Map<String, dynamic> req = {};

    req["receipt-data"] =
        purchaseDetails.verificationData.serverVerificationData;
    // NetworkClient.getInstance.showLoader(context);
    NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.inAppVerfiySandBoxURL,
      command: "",
      params: req,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      successCallback: (response, message) async {
        // NetworkClient.getInstance.hideProgressDialog();
        creditCoin(purchaseDetails);

        return Future<bool>.value(true);
      },
      failureCallback: (code, message) {
        // NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
        return Future<bool>.value(true);
      },
    );
  }

//Credit Coin
  creditCoin(PurchaseDetails purchaseDetails) async {
    var product = listProducts
        .firstWhere((element) => element.id == purchaseDetails.productID);

    Map<String, dynamic> req = {};
    req["gateway"] = "apple";
    req["package_id"] = purchaseDetails.productID;
    req["transaction_id"] = purchaseDetails.purchaseID;
    req["package_name"] = product?.title;
    req["paid_amount"] = product?.rawPrice;
    req["currency"] = product?.currencyCode;
    print(DateTime.fromMillisecondsSinceEpoch(
        purchaseDetails.skPaymentTransaction.transactionTimeStamp.toInt()));

    // NetworkClient.getInstance
    //     .showLoader(NavigationUtilities.key.currentContext);
    await NetworkClient.getInstance.callApi(
      context: NavigationUtilities.key.currentContext,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.buyPackage,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: req,
      successCallback: (response, message) async {
        // NetworkClient.getInstance.hideProgressDialog();

        Provider.of<FollowesProvider>(
                NavigationUtilities.key.currentState.overlay.context,
                listen: false)
            .fetchMyProfile(
                NavigationUtilities.key.currentState.overlay.context);
        View.showMessage(NavigationUtilities.key.currentContext,
            "Your coin credited in your account.",
            mode: DisplayMode.SUCCESS);
      },
      failureCallback: (code, message) {
        // NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(NavigationUtilities.key.currentContext, message);
      },
    );
  }

  openCoinPurchasePopUp() async {
    var _products = await InAppPurchase.instance.getProducts();
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: NavigationUtilities.key.currentContext,
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
                          style: appTheme.black16Bold
                              .copyWith(fontSize: getFontSize(25)),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Close",
                            style: appTheme.black14SemiBold.copyWith(
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
                          style: appTheme.black12Normal.copyWith(
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
                      style: appTheme.black14Normal
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
                                InAppPurchase.instance
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
