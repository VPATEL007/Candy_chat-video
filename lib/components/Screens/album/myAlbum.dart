import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Screens/album/createAlbum.dart';
import 'package:video_chat/provider/album_provider.dart';

import '../../../app/constant/ColorConstant.dart';
import '../../../app/constant/ImageConstant.dart';
import '../../../app/utils/CommonWidgets.dart';
import '../../../app/utils/math_utils.dart';
import '../../../provider/chat_provider.dart';
import '../../Model/album/getAllAlbumModel.dart';

class MyAlbum extends StatefulWidget {
  int coinBalance;

  MyAlbum({Key? key, this.coinBalance = 0}) : super(key: key);

  @override
  State<MyAlbum> createState() => _MyAlbumState();
}

class _MyAlbumState extends State<MyAlbum> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<AlbumProvider>(context, listen: false).getAllAlbums(context);
    });
    // TODO: implement initState
    super.initState();
  }

  void showDialogWithFields(price, id) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Proceed to buy album for \$$price'),
          actions: [
            popUpButton('No', () {
              Navigator.pop(context);
            }),
            popUpButton('Yes', () {
              Navigator.pop(context);
              Provider.of<AlbumProvider>(context, listen: false)
                  .buyAlbum(context, id);
            }),
          ],
        );
      },
    );
  }

  Widget popUpButton(text, onTap) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: ColorConstants.red, // background
        ),
        onPressed: onTap,
        child: Text(text),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainBgColor,
      body: SafeArea(
        child: mainBody(),
      ),
    );
  }

  Widget mainBody() {
    return Consumer<AlbumProvider>(builder: (context, albumProvider, child) {
      List<GetAlbumData> albumList = albumProvider.albumList;
      String noContentLabel = 'No data found';
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
              child: (albumList.isEmpty)
                  ? InkWell(
                      onTap: () {
                        Provider.of<AlbumProvider>(context, listen: false)
                            .getAllAlbums(context);
                      },
                      child: Center(
                        child: Text(
                          noContentLabel,
                          style: appTheme?.black14Normal.copyWith(
                              fontSize: getFontSize(16),
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    )
                  : Container(
                      height: MathUtilities.screenHeight(context) / 1.5,
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 10,
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(albumList.length, (index) {
                          print(
                              'images==> ${albumProvider.albumList[index].images}');
                          return Stack(
                            children: [
                              ClipRRect(
                                child: Container(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: Colors.white.withOpacity(0.0)),
                                  ),
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(albumProvider
                                                .albumList[index]
                                                .coverImage ??
                                            ''),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  // Image.network(albumProvider.albumList[index].coverImage ?? ''),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
              // GridView.builder(
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 3),
              //     itemBuilder: (context, index) {
              //       return Container(
              //         color: Colors.red,
              //         child: Image.asset(icPlaceWoman),
              //       );
              //     })
            ),
            SizedBox(
              height: getSize(16),
            ),
            getBottomButton(context, 'Create Album', () async {
              // Provider.of<AlbumProvider>(context, listen: false)
              //     .getAllAlbums(context);
              bool isCreated = await Navigator.push(
                  context, MaterialPageRoute(builder: (_) => CreateAlbum()));
              if (isCreated)
                Provider.of<AlbumProvider>(context, listen: false)
                    .getAllAlbums(context);
            })
          ],
        ),
      );
    });
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
              child: Icon(Icons.arrow_back_ios, color: Colors.white,)),
          Spacer(),
          Row(
            children: [
              getColorText("My", Colors.white),
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
