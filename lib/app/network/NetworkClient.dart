import 'dart:io';

import 'package:dio/adapter.dart';
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
}

class NetworkClient {
  static NetworkClient _shared;

  NetworkClient._();

  static NetworkClient get getInstance =>
      _shared = _shared ?? NetworkClient._();

  final dio = Dio();

  Map<String, dynamic> getAuthHeaders() {
    Map<String, dynamic> authHeaders = Map<String, dynamic>();

    if (app.resolve<PrefUtils>().isUserLogin()) {
      authHeaders["authorization"] =
          "Bearer " + app.resolve<PrefUtils>().getUserToken();
      print(app.resolve<PrefUtils>().getUserToken);
      authHeaders["Accept"] = "application/json";
    } else {
      authHeaders["Accept"] = "application/json";
    }

    if (Platform.isIOS) {
      authHeaders["deviceType"] = DEVICE_TYPE_IOS;
    } else if (Platform.isAndroid) {
      authHeaders["deviceType"] = DEVICE_TYPE_ANDROID;
    }
    return authHeaders;
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

    if (kDebugMode) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        // config the http client
        client.findProxy = (uri) {
          //proxy all request to localhost:8888
          return ApiConstants.PROXY_URL;
        };
        // you can also create a new HttpClient to dio
        // return new HttpClient();
      };
    }

    switch (method) {
      case MethodType.Post:
        Response response = await dio.post(baseUrl + command, data: params);
        parseResponse(context, response,
            successCallback: successCallback, failureCallback: failureCallback);
        break;

      case MethodType.Get:
        Response response =
            await dio.get(baseUrl + command, queryParameters: params);
        parseResponse(context, response,
            successCallback: successCallback, failureCallback: failureCallback);
        break;

      case MethodType.Put:
        Response response = await dio.put(baseUrl + command, data: params);
        parseResponse(context, response,
            successCallback: successCallback, failureCallback: failureCallback);
        break;

      case MethodType.Delete:
        Response response = await dio.delete(baseUrl + command, data: params);
        parseResponse(context, response,
            successCallback: successCallback, failureCallback: failureCallback);
        break;

      default:
    }
  }

  parseResponse(BuildContext context, Response response,
      {Function(dynamic response, String message) successCallback,
      Function(String statusCode, String message) failureCallback}) {
    int statusCode = response.data['statusCode'];
    String message = response.data['message'];

    if (statusCode == 200 || statusCode == 201) {
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
}
