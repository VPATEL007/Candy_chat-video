import 'dart:io';

import 'package:compressimage/compressimage.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/constants.dart';
import 'package:video_chat/app/utils/math_utils.dart';

Future<FileUploadResp> uploadFile(BuildContext context, String folderName,
    {List<File> files,
    File file,
    List<int> bytes,
    bool pdfUpload = false}) async {
  var dio = Dio();
  dio.options.baseUrl = ApiConstants.documentUpload;

  Response response;
  var formData1 =
      await formdata(folderName, files: files, file: file, bytes: bytes);

  var uploadProgressWidget = UploadProgress(
    state: _UploadProgressState(),
  );
  if (!uploadProgressWidget._isDialogShown) {
    print("progress show Dialog");
    uploadProgressWidget._isDialogShown = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return uploadProgressWidget;
        });
  }
  try {
    response = await dio.post(
      //"/upload",
      ApiConstants.documentUpload,
      data: formData1,
      onSendProgress: (received, total) {
        print(received.toString() + " progress " + total.toString());
        if (total != -1) {
          var perc = (((received * 100) / total) / 100);
          print(perc);

          if (uploadProgressWidget._isDialogShown) {
            print(" progress perc" + perc.toString());
            uploadProgressWidget.state.updateProgress(perc);
          }
          // print(received);
        }
      },
    );
    if (uploadProgressWidget._isDialogShown) {
      uploadProgressWidget.state.updateProgress(1);
    }
    if (response.statusCode == CODE_CREATED)
      return response.data != null
          ? new FileUploadResp.fromJson(response.data)
          : null;
    else {
      print(response.statusMessage);
      print(response.toString());
      // showToast(response.statusMessage);
      return null;
    }
  } catch (e) {
    // showToast(SOMETHING_WENT_WRONG);
    print(e);
    if (uploadProgressWidget._isDialogShown) {
      uploadProgressWidget._isDialogShown = false;
      Navigator.pop(context);
    }
  }
}

Future<FormData> formdata(String folderName,
    {List<File> files,
    File file,
    List<int> bytes,
    bool pdfUpload = false}) async {
  var formData = FormData();
  formData.fields..add(MapEntry("type", folderName));

  if (pdfUpload) {
    await CompressImage.compress(
        imageSrc: file.path,
        desiredQuality: 50); //desiredQuality ranges from 0 to 100
  }

  file = File(file.path);
  if (bytes != null) {
    formData.files.add(MapEntry(
      "files[]",
      MultipartFile.fromBytes(bytes),
    ));
  } else if (files != null) {
    List<MapEntry> entries = List<MapEntry>();

    for (var fl in files) {
      entries.add(
        MapEntry(
          "files[]",
          await MultipartFile.fromFile(
            fl.path,
            filename: fl.path,
          ),
        ),
      );
    }

    formData.files.addAll([entries as MapEntry<dynamic, dynamic>]);
  } else {
    formData.files.add(MapEntry(
      "files[]",
      await MultipartFile.fromFile(file.path,
          filename: path.basename(file.path)),
    ));
  }
  print('formdata ${formData.length}');
  print('formdata ${formData.fields}');

  return formData;
}

class UploadProgress extends StatefulWidget {
  var _isDialogShown = false;

  UploadProgress({this.state});

  _UploadProgressState state;

  @override
  _UploadProgressState createState() => state;
}

class _UploadProgressState extends State<UploadProgress> {
  double percentge;

  void updateProgress(double per) {
    print(per.toString() + "updateProgress");
    if (this.mounted) {
      setState(
        () {
          print(per.toString() + "mounted");
          this.percentge = per;
          if (percentge >= 1.0) {
            if (widget._isDialogShown) {
              widget._isDialogShown = false;
              Navigator.pop(context);
            }
          }
        },
      );
      /*  new Future.delayed(
        const Duration(microseconds: 100),
        () => setState(
          () {
            this.percentge = per;
            if (percentge >= 1.0) {
              Navigator.pop(context);
            }
          },
        ),
      );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getSize(25)),
      ),
      elevation: 0.0,

      // height: MathUtilities.screenHeight(context),
      // backgroundColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(getSize(20)),
        child: Wrap(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  getTitleText(context, "Uploading", ColorConstants.black,
                      fontSize: getSize(20)),
                  Padding(
                    padding: EdgeInsets.only(
                        top: getSize(20),
                        bottom: getSize(16),
                        right: getSize(8),
                        left: getSize(8)),
                    child: new LinearPercentIndicator(
                      width: MathUtilities.screenWidth(context) - getSize(150),
                      lineHeight: 14.0,
                      percent: this.percentge ?? 0,
                      center: getBodyText(
                          context,
                          this.percentge != null
                              ? (this.percentge * 100).toStringAsFixed(2) + "%"
                              : "0.0 %",
                          Colors.white),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      backgroundColor: ColorConstants.introgrey,
                      progressColor: ColorConstants.colorPrimary,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

getBodyText(BuildContext context, String text, Color color,
    {double fontSize, TextAlign align}) {
  return Text(
    text,
    textAlign: align ?? TextAlign.left,
    style: Theme.of(context).textTheme.body1.copyWith(
          fontSize: fontSize == null ? getSize(14) : fontSize,
          color: color,
        ),
  );
}

getTitleText(BuildContext context, String text, Color color,
    {double fontSize, TextAlign align}) {
  return Text(
    text,
    textAlign: align ?? TextAlign.left,
    style: Theme.of(context).textTheme.title.copyWith(
          fontSize: fontSize == null ? getSize(14) : fontSize,
          color: color,
        ),
  );
}

class FileUploadResp extends Response {
  String code;
  String message;
  Data detail;

  FileUploadResp({this.code, this.message, this.detail});

  FileUploadResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    detail = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.detail != null) {
      data['data'] = this.detail.toJson();
    }
    return data;
  }
}

class Data {
  List<int> ids;

  Data({this.ids});

  Data.fromJson(Map<String, dynamic> json) {
    ids = json['ids'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ids'] = this.ids;
    return data;
  }
}
