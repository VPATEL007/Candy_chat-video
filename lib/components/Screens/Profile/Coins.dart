import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';

class Coins extends StatefulWidget {
  const Coins({Key key}) : super(key: key);

  @override
  _CoinsState createState() => _CoinsState();
}

class _CoinsState extends State<Coins> {
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  List<String> _kProductIds = <String>[
    "com.randomvideochat.videochat.30",
    "com.randomvideochat.videochat.203"
  ];
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      setState(() {
        _products = [];

        _notFoundIds = [];
      });
      return;
    }

    NetworkClient.getInstance.showLoader(context);
    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.productDetails != null) {
      _products = productDetailResponse.productDetails;
      _products.sort((a, b) {
        return a.rawPrice.compareTo(b.rawPrice);
      });
      ;
      _notFoundIds = productDetailResponse.notFoundIDs;
    } else {
      _products = [];
    }

    setState(() {
      NetworkClient.getInstance.hideProgressDialog();
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          deliverProduct(purchaseDetails);
        } else {}
      } else {}
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.

    return Future<bool>.value(true);
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
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
                          purchaseProduct(_products[index]);
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
      ],
    );
  }

//Purchase
  purchaseProduct(ProductDetails product) {
    PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: null,
        changeSubscriptionParam: null);
    _connection.buyConsumable(purchaseParam: purchaseParam);
  }
}
