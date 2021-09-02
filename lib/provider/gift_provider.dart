import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/navigator.dart';
import 'package:video_chat/components/Model/Gift/GiftModel.dart';

class GiftProvider with ChangeNotifier {
  List<GiftModel> _giftList = [];
  List<GiftModel> get giftList => this._giftList;

  set giftList(List<GiftModel> value) => this._giftList = value;

//Get Gift List
  Future<void> fetchGift(BuildContext context, int page) async {
    try {
      Map<String, dynamic> req = {};
      req["page"] = page;
      req["pageSize"] = 20;
      if (page == 1) NetworkClient.getInstance.showLoader(context);
      await NetworkClient.getInstance.callApi(
        context: context,
        params: req,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.fetchGift,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          if (page == 1) NetworkClient.getInstance.hideProgressDialog();
          if (response["rows"] != null) {
            if (page == 1) {
              giftList = giftModelFromJson(jsonEncode(response["rows"]));
            } else {
              giftList.addAll(giftModelFromJson(jsonEncode(response["rows"])));
            }
          }

          notifyListeners();
        },
        failureCallback: (code, message) {
          if (page == 1) NetworkClient.getInstance.hideProgressDialog();
          View.showMessage(context, message);
        },
      );
    } catch (e) {
      if (page == 1) NetworkClient.getInstance.hideProgressDialog();
      View.showMessage(context, e.toString());
    }
  }

//Buy Gift
  Future<void> buyGift(BuildContext context, int userId, int giftId) async {
    try {
      Map<String, dynamic> req = {};

      req["to_user_id"] = userId;
      req["gift_id"] = giftId;
      NetworkClient.getInstance.showLoader(context);
      await NetworkClient.getInstance.callApi(
        context: context,
        params: req,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.buyGift,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Post,
        successCallback: (response, message) {
          NetworkClient.getInstance.hideProgressDialog();
          View.showMessage(context, message, mode: DisplayMode.SUCCESS);
          notifyListeners();
        },
        failureCallback: (code, message) {
          NetworkClient.getInstance.hideProgressDialog();
          View.showMessage(context, message);
        },
      );
    } catch (e) {
      NetworkClient.getInstance.hideProgressDialog();
      View.showMessage(context, e.toString());
    }
  }

//Open Gift Pop Up
  openGiftPopUp(int userId) async {
    int page = 1;
    await fetchGift(NavigationUtilities.key.currentState.overlay.context, page);
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: NavigationUtilities.key.currentState.overlay.context,
        builder: (builder) {
          return Consumer<GiftProvider>(
            builder: (context, giftProvider, child) {
              return StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: getSize(23),
                          left: getSize(26),
                          right: getSize(26)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Gift",
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
                            height: getSize(18),
                          ),
                          Container(
                            height: getSize(150),
                            child: GridView.builder(
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                shrinkWrap: true,
                                itemCount: giftProvider.giftList.length,
                                primary: false,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return LazyLoadingList(
                                    initialSizeOfItems: 20,
                                    loadMore: () {
                                      page++;
                                      fetchGift(
                                          NavigationUtilities
                                              .key.currentState.overlay.context,
                                          page);
                                    },
                                    index: index,
                                    hasMore: true,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        buyGift(context, userId,
                                            giftProvider.giftList[index].id);
                                      },
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: giftProvider
                                                    .giftList[index].imageUrl ??
                                                "",
                                            width: getSize(45),
                                            height: getSize(45),
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              noAttachment,
                                              fit: BoxFit.cover,
                                              height: getSize(45),
                                              width: getSize(45),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            giftProvider
                                                    .giftList[index].price ??
                                                "",
                                            style: appTheme.black_Medium_14Text,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: getSize(35),
                          ),
                          getPopBottomButton(context, "Submit", () {
                            Navigator.pop(context);
                          })
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        });
  }
}
