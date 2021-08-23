import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:video_chat/app/Helper/inAppPurchase_service.dart';
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
  InAppPurchase purchase = InAppPurchase.instance;

  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  getList() async {
    _products = await purchase.getProducts(context);
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
      ],
    );
  }
}
