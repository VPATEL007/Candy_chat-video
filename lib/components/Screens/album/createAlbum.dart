import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/provider/album_provider.dart';

import '../../../app/Helper/Themehelper.dart';
import '../../../app/constant/ColorConstant.dart';
import '../../../app/constant/ImageConstant.dart';
import '../../../app/constant/constants.dart';
import '../../../app/utils/CommonWidgets.dart';
import '../../../app/utils/math_utils.dart';
import '../../Model/User/UserModel.dart';

class CreateAlbum extends StatefulWidget {
  const CreateAlbum({Key? key}) : super(key: key);

  @override
  State<CreateAlbum> createState() => _CreateAlbumState();
}

class _CreateAlbumState extends State<CreateAlbum> {
  List<Asset> albumList = [];
  String selectedPrice = price300.toString();
  List<String> priceList = [price300.toString(), price500.toString()];
  bool isCreated = false;

  loadAssets() async {
    // int? maxImageSelectLength = _userInfo?.userImages!
    //     .where((maxImage) => maxImage.id == null)
    //     .toList()
    //     .length;
    try {
      List<Asset> _resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: [],
        materialOptions: MaterialOptions(
          actionBarTitle: "Video chat App",
        ),
      );
      if (_resultList.isNotEmpty) {
        for (var i = 0; i <= _resultList.length; i++) {
          // final String filePath = _resultList[i].identifier ?? '';
          setState(() {
            albumList.add(_resultList[i]);
          });
        }
      }
      print('resultList==> ${_resultList[0].identifier}');
    } on PlatformException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Future<bool> _willPopCallback() async {
    Navigator.pop(context, isCreated);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: ColorConstants.mainBgColor,
        body: SafeArea(
          child: Container(
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
                      crossAxisCount: 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 10,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                          albumList.isEmpty ? 1 : albumList.length + 1,
                          (index) {
                        print('albumList.length==> ${albumList.length}');
                        if (index == 0 || albumList.isEmpty) {
                          print('index from if==> $index');
                          return InkWell(
                            onTap: () {
                              loadAssets();
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Image.asset(icAddAlbum),
                            ),
                          );
                        }
                        // print('index==> $index');
                        return Stack(
                          children: [
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: AssetThumb(
                                  asset: Asset(albumList[index - 1].identifier,
                                      albumList[index - 1].name, 100, 100),
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                            cancelIcon(() {
                              if (mounted) {
                                setState(() {
                                  albumList.removeAt(index - 1);
                                });
                              }
                            }, right: 3.0)
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(
                  height: getSize(16),
                ),
                Container(
                    padding: EdgeInsets.only(left: getSize(16)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Rate',
                      style: appTheme?.black14Normal,
                    )),
                SizedBox(
                  height: getSize(5),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      getSize(16),
                      getSize(0),
                      getSize(16),
                      MathUtilities.safeAreaBottomHeight(context) +
                          getSize(16)),
                  child: Container(
                    height: getSize(50),
                    alignment: Alignment.center,
                    width: MathUtilities.screenWidth(context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        getSize(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorConstants.gradiantStart,
                          ColorConstants.red
                        ],
                      ),
                    ),
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: ColorConstants.red,
                      ),
                      child: priceDropDown(),
                    ),
                  ),
                ),
                getBottomButton(context, 'Publish', () {
                  if (albumList.isEmpty) {
                    View.showMessage(context, 'Please select at least 1 image');
                    return;
                  }
                  Provider.of<AlbumProvider>(context, listen: false)
                      .createAlbum(context, albumList, selectedPrice);
                  isCreated = true;
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget priceDropDown() => DropdownButton(
      underline: SizedBox(),
      isExpanded: true,
      style: appTheme?.white14Normal,
      hint: Text('Select Price'),
      value: selectedPrice,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: priceList.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          selectedPrice = newValue!;
        });
      });

  Widget getNavigation() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                Navigator.pop(context, isCreated);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white,)),
          Spacer(),
          Row(
            children: [
              getColorText("Create", Colors.white),
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
