import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/store_kit_wrappers.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/app/utils/pref_utils.dart';

import '../../main.dart';

class InAppPurchase {
  InAppPurchase._();

  static InAppPurchase instance = InAppPurchase._();
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  BuildContext context;
  StreamSubscription<List<PurchaseDetails>> subscription;
  List<String> _kProductIds = <String>[
    "com.randomvideochat.videochat.30",
    "com.randomvideochat.videochat.203"
  ];

//Get Product
  Future<List<ProductDetails>> getProducts(BuildContext context1) async {
    intialConfig();
    context = context1;
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      return [];
    }

    List<ProductDetails> products = [];

    NetworkClient.getInstance.showLoader(context);
    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.productDetails != null) {
      products = productDetailResponse.productDetails;
      products.sort((a, b) {
        return a.rawPrice.compareTo(b.rawPrice);
      });
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
        await verifyPurchase(purchaseDetails, context);
        completeTransaction();
      }
    });
  }

  //Complete Transaction
  Future<void> completeTransaction() async {
    var transactions = await SKPaymentQueueWrapper().transactions();
    transactions.forEach((skPaymentTransactionWrapper) {
      SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
    });
  }

  //Purchase
  purchaseProduct(ProductDetails product) {
    PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: app.resolve<PrefUtils>().getUserDetails().userName,
        changeSubscriptionParam: null,
        sandboxTesting: false);
    _connection.buyConsumable(purchaseParam: purchaseParam);
  }

//Verify Purchase
  Future<bool> verifyPurchase(
      PurchaseDetails purchaseDetails, BuildContext context) {
    Map<String, dynamic> req = {};

    req["receipt-data"] =
        purchaseDetails.verificationData.serverVerificationData;
    NetworkClient.getInstance.showLoader(context);
    NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.inAppVerfiySandBoxURL,
      command: "",
      params: req,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      successCallback: (response, message) async {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, "Your coin credited in your account.",
            mode: DisplayMode.SUCCESS);
        return Future<bool>.value(true);
      },
      failureCallback: (code, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
        return Future<bool>.value(true);
      },
    );
  }
}
