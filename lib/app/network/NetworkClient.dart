import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';

import '../app.export.dart';

class MethodType {
  static const String Post = "POST";
  static const String Get = "GET";
  static const String Put = "PUT";
  static const String Delete = "DELETE";
  static const String Patch = "PATCH";
}

class NetworkClient {
  static NetworkClient _shared;

  NetworkClient._();

  static NetworkClient get getInstance =>
      _shared = _shared ?? NetworkClient._();

  final dio = Dio();

  Map<String, dynamic> getAuthHeaders({bool isRefereshToken = false}) {
    Map<String, dynamic> authHeaders = Map<String, dynamic>();

    if (app.resolve<PrefUtils>().isUserLogin()) {
      if (isRefereshToken) {
        authHeaders["authorization"] = app
            .resolve<PrefUtils>()
            .getUserToken(isRefereshToken: isRefereshToken);
      } else {
        authHeaders["authorization"] =
            "Bearer " + app.resolve<PrefUtils>().getUserToken();
      }
    }

    authHeaders["Accept"] = "application/json";
    if (Platform.isIOS) {
      authHeaders["deviceType"] = DEVICE_TYPE_IOS;
    } else if (Platform.isAndroid) {
      authHeaders["deviceType"] = DEVICE_TYPE_ANDROID;
    }
    return authHeaders;
  }

  Future<Response> uploadImages({
    @required BuildContext context,
    @required String baseUrl,
    @required String command,
    @required String image,
    Map<String, dynamic> headers,
    @required Function(dynamic response, String message) successCallback,
    @required Function(String message, String statusCode) failureCallback,
  }) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      failureCallback("", "No Internet Connection");
      return null;
    }

    dio.options.validateStatus = (status) {
      return status < 500;
    };
    dio.options.connectTimeout = 50000; //5s
    dio.options.receiveTimeout = 50000;

    if (headers != null) {
      for (var key in headers.keys) {
        dio.options.headers[key] = headers[key];
      }
    }

    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        image,
        filename:
            'image_${DateTime.now().microsecondsSinceEpoch.toString()}.jpg',
      ),
    });
    var response = await dio.post(
      baseUrl + command,
      data: formData,
    );

    parseResponse(context, response,
        successCallback: successCallback, failureCallback: failureCallback);
  }

  Future<Response> callApi({
    @required BuildContext context,
    @required String baseUrl,
    @required String command,
    @required String method,
    Map<String, dynamic> params,
    Map<String, dynamic> headers,
    @required Function(dynamic response, String message) successCallback,
    @required Function(String message, String statusCode) failureCallback,
  }) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      failureCallback("", "No Internet Connection");
      return null;
    }

    print(
        "Call Api: URL: ${baseUrl + command} Method: $method Parms: $params Headers: $headers");

    dio.options.validateStatus = (status) {
      return status < 500;
    };
    dio.options.connectTimeout = 50000; //5s
    dio.options.receiveTimeout = 50000;

    if (headers != null) {
      for (var key in headers.keys) {
        dio.options.headers[key] = headers[key];
      }
    }

    // if (kDebugMode) {
    //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (client) {
    //     // config the http client
    //     client.findProxy = (uri) {
    //       return ApiConstants.PROXY_URL;
    //     };
    //   };
    // }

    switch (method) {
      case MethodType.Post:
        try {
          Response response = await dio.post(baseUrl + command, data: params);
          parseResponse(context, response,
              successCallback: successCallback,
              failureCallback: failureCallback);
        } on DioError catch (e) {
          if (e.message.toString().toLowerCase() ==
              "Connecting timed out [1ms]".toLowerCase()) {
            failureCallback("", "Connection timeout, Please try again. ");
          } else {
            failureCallback("", e.message.toString());
          }
        } catch (e) {
          failureCallback("", e.toString());
        }

        break;

      case MethodType.Get:
        try {
          Response response =
              await dio.get(baseUrl + command, queryParameters: params);
          parseResponse(context, response,
              successCallback: successCallback,
              failureCallback: failureCallback);
        } on DioError catch (e) {
          if (e.message.toString().toLowerCase() ==
              "Connecting timed out [1ms]".toLowerCase()) {
            failureCallback("", "Connection timeout, Please try again. ");
          } else {
            if (e.response != null) {
              failureCallback("", e?.response?.data["message"].toString());
            } else {
              failureCallback("", e.message.toString());
            }
          }
        } catch (e) {
          failureCallback("", e.toString());
        }

        break;

      case MethodType.Put:
        try {
          Response response = await dio.put(baseUrl + command, data: params);
          parseResponse(context, response,
              successCallback: successCallback,
              failureCallback: failureCallback);
        } on DioError catch (e) {
          if (e.message.toString().toLowerCase() ==
              "Connecting timed out [1ms]".toLowerCase()) {
            failureCallback("", "Connection timeout, Please try again. ");
          } else {
            failureCallback("", e.message.toString());
          }
        } catch (e) {
          failureCallback("", e.toString());
        }

        break;

      case MethodType.Delete:
        try {
          Response response = await dio.delete(baseUrl + command, data: params);
          parseResponse(context, response,
              successCallback: successCallback,
              failureCallback: failureCallback);
        } on DioError catch (e) {
          if (e.message.toString().toLowerCase() ==
              "Connecting timed out [1ms]".toLowerCase()) {
            failureCallback("", "Connection timeout, Please try again. ");
          } else {
            failureCallback("", e.message.toString());
          }
        } catch (e) {
          failureCallback("", e.toString());
        }

        break;
      case MethodType.Patch:
        try {
          Response response = await dio.patch(baseUrl + command, data: params);
          parseResponse(context, response,
              successCallback: successCallback,
              failureCallback: failureCallback);
        } on DioError catch (e) {
          if (e.message.toString().toLowerCase() ==
              "Connecting timed out [1ms]".toLowerCase()) {
            failureCallback("", "Connection timeout, Please try again. ");
          } else {
            failureCallback("", e.message.toString());
          }
        } catch (e) {
          failureCallback("", e.toString());
        }

        break;

      default:
    }
  }

  parseResponse(BuildContext context, Response response,
      {Function(dynamic response, String message) successCallback,
      Function(String statusCode, String message) failureCallback}) {
    String statusCode = response.data['status'].toString();
    String message = response.data['message'];

    if (statusCode == "0") {
      int status = response.data['status'];

      if (status == 0) {
        successCallback(response, "");
      } else {
        failureCallback(response.toString(), "Purchase fail");
      }
      return;
    }

    if (statusCode == "success") {
      if (response.data["data"] is Map<String, dynamic> ||
          response.data["data"] is List<dynamic>) {
        successCallback(response.data["data"], message);
        return;
      } else if (response.data["data"] is List<Map<String, dynamic>>) {
        successCallback(response.data["data"], message);
        return;
      } else {
        successCallback(response.data["data"], message);
        // failureCallback("$statusCode", message);
        return;
      }
    }
    // else if (statusCode == 404) {
    //   // // print(app.resolve<PrefUtils>().isUserLogin());
    //   // if (app.resolve<PrefUtils>().isUserLogin()) {
    //   //   showToast(message, context: context);
    //   //   app.resolve<PrefUtils>().resetAndLogout(context);
    //   //   return;
    //   // } else {
    //   //   failureCallback(statusCode, message);
    //   //   return;
    //   // }
    //   failureCallback("$statusCode", message);
    // }

    failureCallback("$statusCode", message);
    return;
  }

  Future<void> showLoader(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return Future.value(false);
            },
            child: SpinKitFadingCircle(
              color: Colors.white,
              size: 50.0,
            ),
          );
        });
  }

  void hideProgressDialog() {
    Navigator.pop(NavigationUtilities.key.currentState.overlay.context);
  }

  void refereshToken(
      {@required BuildContext context, Function success, Function failure}) {
    NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.allLanguage,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      successCallback: (response, message) async {
        app.resolve<PrefUtils>().saveRefereshToken(response["refreshToken"]);
        app.resolve<PrefUtils>().saveUserToken(response["accessToken"]);
        success();
      },
      failureCallback: (code, message) {
        failure();
      },
    );
  }
}
