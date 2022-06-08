import 'package:flutter/material.dart';

import '../../../app/constant/ColorConstant.dart';
import '../../../app/utils/CommonWidgets.dart';
import '../../../app/utils/math_utils.dart';

class ViewAlbum extends StatefulWidget {
  List<String>? images;

  ViewAlbum({Key? key, this.images}) : super(key: key);

  @override
  State<ViewAlbum> createState() => _ViewAlbumState();
}

class _ViewAlbumState extends State<ViewAlbum> {
  List<String> images = [];

  @override
  void initState() {
    images = widget.images ?? [];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: mainBody(),
      ),
    );
  }

  Widget mainBody() {
    return Container(
      padding: EdgeInsets.only(left: getSize(25), right: getSize(25)),
      child: Column(
        children: [
          SizedBox(
            height: getSize(16),
          ),
          getNavigation(),
          SizedBox(
            height: getSize(16),
          ),
          Expanded(
            child: Container(
              height: MathUtilities.screenHeight(context) / 1.5,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(images.length, (index) {
                  print('images==> ${images[index]}');
                  return Stack(
                    children: [
                      ClipRRect(
                        child: Container(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.white.withOpacity(0.0)),
                          ),
                          height: 200,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(images[index]),
                              ),
                              borderRadius: BorderRadius.circular(15.0)),
                          // Image.network(albumProvider.albumList[index].coverImage ?? ''),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getNavigation() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          Spacer(),
          Row(
            children: [
              getColorText("Private", Colors.black),
              SizedBox(
                width: getSize(6),
              ),
              getColorText("Album", ColorConstants.red),
            ],
          ),
          Spacer(),
        ]);
  }
}
