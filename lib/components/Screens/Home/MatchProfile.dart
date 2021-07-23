import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';

import 'Card/swipe_cards.dart';

class MathProfile extends StatefulWidget {
  MathProfile({Key key}) : super(key: key);

  @override
  _MathProfileState createState() => _MathProfileState();
}

class _MathProfileState extends State<MathProfile> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> _names = ["Red", "Blue", "Green", "Yellow", "Orange"];

  @override
  void initState() {
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
          content: Content(text: _names[i]),
          likeAction: () {
            print("like");
          },
          nopeAction: () {
            print("nope");
          },
          superlikeAction: () {
            print("supper");
          }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SwipeCards(
            matchEngine: _matchEngine,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(icTemp),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: getSize(29), top: getSize(100)),
                        child: Container(
                          height: getSize(120),
                          width: getSize(90),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(
                              getSize(7),
                            ),
                          ),
                          child: Image.asset(icTemp),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            onStackFinished: () {
              print("asdad");
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [TabBarWidget()],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Content {
  final String text;

  Content({this.text});
}
