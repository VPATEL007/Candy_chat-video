import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';

class CoinList extends StatefulWidget {
  CoinList({Key key}) : super(key: key);

  @override
  _CoinListState createState() => _CoinListState();
}

class _CoinListState extends State<CoinList> {
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
