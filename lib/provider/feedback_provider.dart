import 'dart:convert';

import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/device_info.dart';
import 'package:video_chat/components/Model/settings/feedback.dart';

class FeedBackProvider with ChangeNotifier {
  List<FeedBackModel> _feedBackList = [];

  List<FeedBackModel> get feedBackList => this._feedBackList;

  set feedBackList(List<FeedBackModel> value) => this._feedBackList = value;

// Fetch feedbacks...
  Future<void> fetchFeedBacks(BuildContext context) async {
    try {
      await NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.feedbacks,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          feedBackList = feedBackModelFromJson(jsonEncode(response));
          notifyListeners();
        },
        failureCallback: (code, message) {
          View.showMessage(context, message);
        },
      );
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  // Submit feedback...
  Future<void> submitFeedBack(BuildContext context, int categoryId,
      List<Asset> images, String comment) async {
    try {
      List<String> feedBackUrl = [];

      if (null != images) {
        for (Asset asset in images) {
          final filePath =
              await FlutterAbsolutePath.getAbsolutePath(asset.identifier ?? "");
          String compressPath = await compressImage(filePath);

          await NetworkClient.getInstance.uploadImages(
            context: context,
            baseUrl: ApiConstants.apiUrl,
            command: "app-home-screen/upload-image",
            headers: NetworkClient.getInstance.getAuthHeaders(),
            image: compressPath,
            successCallback: (response, message) {
              feedBackUrl.add(response ?? "");
            },
            failureCallback: (code, message) {
              View.showMessage(context, message);
            },
          );
        }
      }
      String osInfo = await fetchDeviceOsInfo();
      final PackageInfo info = await PackageInfo.fromPlatform();
      Map<String, dynamic> block = {
        "category_id": categoryId,
        "images": feedBackUrl,
        "text": comment,
        "app_os": io.Platform.isAndroid
            ? "Android"
            : io.Platform.isIOS
                ? "Ios"
                : "Unknown",
        "app_os_version": osInfo,
        "app_version": (info.version) + (info.buildNumber)
      };

      print(block);
      await NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: "feedback/app-feedback",
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Post,
        params: block,
        successCallback: (response, message) {
          View.showMessage(context, message, mode: DisplayMode.SUCCESS);
        },
        failureCallback: (code, message) {
          View.showMessage(context, message);
        },
      );

      notifyListeners();
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  // Compress image...
  Future<String> compressImage(String oriImgPath) async {
    try {
      if ((oriImgPath.isEmpty)) return "";

      final io.Directory tempDir = await getTemporaryDirectory();

      String targetPath =
          tempDir.path + "/" + DateTime.now().toString() + ".jpeg";
      io.File? compressedFile = await FlutterImageCompress.compressAndGetFile(
          oriImgPath, targetPath,
          quality: 75);

      return compressedFile?.path ?? oriImgPath;
    } catch (e) {
      print(e);
      return oriImgPath;
    }
  }
}
