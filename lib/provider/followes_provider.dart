import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Follwers/follow_model.dart';
import 'package:video_chat/components/Model/Match%20Profile/search_profile.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';

import 'discover_provider.dart';

class FollowesProvider with ChangeNotifier {
  List<FollowesModel> _followersList = [];
  List<FollowesModel> _followingList = [];
  List<SearchProfileData> _searchList = [];
  UserModel? userModel;

  List<FollowesModel> get followingList => this._followingList;

  set followingList(List<FollowesModel> value) => this._followingList = value;

  List<FollowesModel> get followersList => this._followersList;

  set followersList(List<FollowesModel> value) => this._followersList = value;

  List<SearchProfileData> get searchList => this._searchList;

  set searchList(List<SearchProfileData> value) => this._searchList = value;

  // Fetch followes...
  Future<void> fetchFollowes(BuildContext context,
      {bool fetchInBackground = true, int pageNumber = 1}) async {
    Map<String, dynamic> _parms = {"page": pageNumber};
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.getFollowes,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      params: _parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        print(response["rows"]);
        if (response["rows"] != null) {
          List<FollowesModel> arrList =
              followesModelFromJson(jsonEncode(response["rows"]));
          if (pageNumber == 1) {
            followersList = arrList;
          } else {
            followersList.addAll(arrList);
          }
        }
      },
      failureCallback: (code, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }

  // Fetch following...
  Future<void> fetchFollowing(BuildContext context,
      {bool fetchInBackground = true, int pageNumber = 1}) async {
    Map<String, dynamic> _parms = {"page": pageNumber};
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.getFollowing,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      params: _parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        print(response["rows"]);
        if (response["rows"] != null) {
          List<FollowesModel> arrList =
              followesModelFromJson(jsonEncode(response["rows"]));
          if (pageNumber == 1) {
            followingList = arrList;
          } else {
            followingList.addAll(arrList);
          }
        }
      },
      failureCallback: (code, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }

  Future<void> fetchSearchUser(BuildContext context,
      {bool fetchInBackground = true,
      int pageNumber = 1,
      size = 20,
      keyword = ''}) async {
    Map<String, dynamic> _parms = {
      "page": pageNumber,
      "size": size,
      "keyword": keyword
    };
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.getAllByInfluencer,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      params: _parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        print(response["result"]["data"]);
        if (response["result"]["data"] != null) {
          print('response==> $response');

          SearchProfileResult searchProfileModel =
              SearchProfileResult.fromJson(response['result']);
          print('searchProfileModel==> ${searchProfileModel.totalRecords}');
          if (pageNumber == 1) {
            searchList = searchProfileModel.data ?? [];
          } else {
            searchList.addAll(searchProfileModel.data ?? []);
          }
        }
      },
      failureCallback: (code, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }

  // Unfollow user
  Future<void> unfollowUser(
    BuildContext context,
    int userId, {
    bool fetchInBackground = true,
  }) async {
    _followingList.removeWhere((element) => element.byUser?.id == userId);
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.unFollowUser,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: {"userId": userId},
      successCallback: (response, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        if (userModel?.byUserUserFollowers != null) {
          userModel?.byUserUserFollowers =
              (userModel?.byUserUserFollowers ?? 0) - 1;
        }
        View.showMessage(context, message, mode: DisplayMode.SUCCESS);
        Provider.of<DiscoverProvider>(context, listen: false)
            .fetchDiscoverProfileList(context, SortBy.General);
      },
      failureCallback: (code, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }

  // favourite user
  Future<void> favouriteUnfavouriteUser(
      BuildContext context, int userId, FavouriteStatus favouriteStatus) async {
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: "favourite/${describeEnum(favouriteStatus)}",
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: {"user_id": userId},
      successCallback: (response, message) {
        View.showMessage(context, message, mode: DisplayMode.SUCCESS);
        Provider.of<DiscoverProvider>(context, listen: false)
            .fetchDiscoverProfileList(context, SortBy.General);
      },
      failureCallback: (code, message) {
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }

  // follow user
  Future<void> followUser(
    BuildContext context,
    int userId,
  ) async {
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.followUser,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: {"userId": userId},
      successCallback: (response, message) {
        if (userModel?.byUserUserFollowers != null) {
          userModel?.byUserUserFollowers =
              (userModel?.byUserUserFollowers ?? 0) + 1;
          Provider.of<DiscoverProvider>(context, listen: false)
              .fetchDiscoverProfileList(context, SortBy.General);
        }
        View.showMessage(context, message, mode: DisplayMode.SUCCESS);
      },
      failureCallback: (code, message) {
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }

  // Fetch my profile...
  Future<void> fetchMyProfile(
    BuildContext context,
  ) async {
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.myProfile,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      successCallback: (response, message) {
        userModel = userModelFromJson(jsonEncode(response));
        UserModel model = userModelFromJson(jsonEncode(response));
        app.resolve<PrefUtils>().saveUser(model, isLoggedIn: true);
        print('response fetchMyProfile==> ${response["userData"]}');
        notifyListeners();
      },
      failureCallback: (code, message) {
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }

  // SAve my profile...
  Future<void> saveMyProfile(
      BuildContext context, UserModel? userInfo, List<int> removeImage) async {
    List<String> profileImages = [];

    if (null != userInfo?.userImages) {
      for (var i = 0; i < (userInfo!.userImages?.length ?? 0); i++) {
        if (userInfo.userImages?[i].photoUrl.isNotEmpty == true &&
            userInfo.userImages?[i].id == null) {
          final filePath = await FlutterAbsolutePath.getAbsolutePath(
              userInfo.userImages?[i].photoUrl ?? "");
          String compressPath = await compressImage(filePath);

          await NetworkClient.getInstance.uploadImages(
            context: context,
            baseUrl: ApiConstants.apiUrl,
            command: "app-home-screen/upload-image",
            headers: NetworkClient.getInstance.getAuthHeaders(),
            image: compressPath,
            successCallback: (response, message) {
              profileImages.add(response ?? "");
            },
            failureCallback: (code, message) {
              View.showMessage(context, message);
            },
          );
        }
      }
    }
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.updateProfile,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: {
        "id": userInfo?.id,
        "user_name": userInfo?.userName,
        "dob": userInfo?.dob,
        "gender": userInfo?.gender?.toLowerCase(),
        "image_add": profileImages,
        "image_remove": removeImage,
        "about": userInfo?.about ?? "",
        "phone": userInfo?.phone ?? ""
      },
      successCallback: (response, message) {
        // userModel = userModelFromJson(jsonEncode(response));
        fetchMyProfile(context);
        View.showMessage(context, message, mode: DisplayMode.SUCCESS);
      },
      failureCallback: (code, message) {
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }

  // Compress image...
  Future<String> compressImage(String oriImgPath) async {
    try {
      if ((oriImgPath.isEmpty)) return "";

      final tempDir = await getTemporaryDirectory();

      String targetPath =
          tempDir.path + "/" + DateTime.now().toString() + ".jpeg";
      File? compressedFile = await FlutterImageCompress.compressAndGetFile(
          oriImgPath, targetPath,
          quality: 75);

      return compressedFile?.path ?? oriImgPath;
    } catch (e) {
      print(e);
      return oriImgPath;
    }
  }
}

enum FavouriteStatus { add, delete, none }
