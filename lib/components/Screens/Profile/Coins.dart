import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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
  ];
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;

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
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    // final QueryPurchaseDetailsResponse purchaseResponse =
    //     await _connection.queryPastPurchases();
    // if (purchaseResponse.error != null) {
    //   // handle query past purchase error..
    // }
    // final List<PurchaseDetails> verifiedPurchases = [];
    // for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
    //   if (await _verifyPurchase(purchase)) {
    //     verifiedPurchases.add(purchase);
    //   }
    // }
    // List<String> consumables = await ConsumableStore.load();
    // setState(() {
    //   _isAvailable = isAvailable;
    //   _products = productDetailResponse.productDetails;
    //   _purchases = verifiedPurchases;
    //   _notFoundIds = productDetailResponse.notFoundIDs;
    //   _consumables = consumables;
    //   _purchasePending = false;
    //   _loading = false;
    // });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {}
    });
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
                  itemCount: 15,
                  padding:
                      EdgeInsets.only(left: getSize(28), right: getSize(28)),
                  itemBuilder: (BuildContext context, int index) {
                    return getCoinItem(index == 1, context);
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
}
