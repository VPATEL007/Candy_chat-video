import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:provider/provider.dart';

import '../app/app.export.dart';
import '../app/utils/image_utils.dart';
import '../components/Model/album/getAllAlbumModel.dart';
import '../app/utils/ImageUtils.dart';

class AlbumProvider with ChangeNotifier {
  List<GetAlbumData> _albumList = [];

  List<GetAlbumData> get albumList => this._albumList;

  set albumList(List<GetAlbumData> value) => this._albumList = value;

  Future<void> buyAlbum(context, id) async {
    NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.buyAlbum,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: {
        "album_id": id,
      },
      successCallback: (response, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message, mode: DisplayMode.SUCCESS);
        print('respose==> $response');
        getAllAlbums(context);
      },
      failureCallback: (code, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
        print('createAlbum: $message $code');
      },
    );
  }

  Future<void> getAllAlbums(context) async {
    try {
      int? userId = app.resolve<PrefUtils>().getUserDetails()?.id;
      Map<String, dynamic> _parms = {
        "user_id": userId,
      };
      NetworkClient.getInstance.showLoader(context);
      await NetworkClient.getInstance.callApi(
          context: context,
          params: _parms,
          baseUrl: ApiConstants.apiUrl,
          command: ApiConstants.getAllAlbums,
          headers: NetworkClient.getInstance.getAuthHeaders(),
          method: MethodType.Post,
          successCallback: (response, message) {
            List<GetAlbumData>? arrList =
                albumModelFromJson(jsonEncode(response));
            albumList = arrList;
            notifyListeners();
            NetworkClient.getInstance.hideProgressDialog();
          },
          failureCallback: (code, message) {
            print(message);
            NetworkClient.getInstance.hideProgressDialog();
            View.showMessage(context, message);
          });
    } catch (e) {
      NetworkClient.getInstance.hideProgressDialog();
      View.showMessage(context, e.toString());
    }
  }

  Future<void> createAlbum(BuildContext context, images, rate) async {
    List<String> profileImages = [];
    try {
      NetworkClient.getInstance.showLoader(context);
      if (images.isNotEmpty) {
        for (var i = 0; i < (images.length); i++) {
          final filePath =
              await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
          String compressPath = await ImageUtils().compressImage(filePath);
          await NetworkClient.getInstance.uploadImages(
            context: context,
            baseUrl: ApiConstants.apiUrl,
            command: "app-home-screen/upload-image",
            headers: NetworkClient.getInstance.getAuthHeaders(),
            image: compressPath,
            successCallback: (response, message) {
              print('response==> $response');
              profileImages.add(response ?? "");
            },
            failureCallback: (code, message) {
              View.showMessage(context, message);
            },
          );
        }
      }
      await NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.createAlbum,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Post,
        params: {
          "rate": rate,
          "cover_image": profileImages[0],
          "images": profileImages,
        },
        successCallback: (response, message) {
          NetworkClient.getInstance.hideProgressDialog();
          View.showMessage(context, message, mode: DisplayMode.SUCCESS);
          print('respose==> $response');
        },
        failureCallback: (code, message) {
          NetworkClient.getInstance.hideProgressDialog();
          View.showMessage(context, message);
          print('createAlbum: $message');
        },
      );
    } catch (e) {
      View.showMessage(context, e.toString(), mode: DisplayMode.SUCCESS);
      print('createAlbum: $e');
    }
  }
}
