// For generate Map
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';

CachedNetworkImage getImageView(String url,
    {height = 100.0,
    width = 100.0,
    placeHolderImage,
    fit: BoxFit.contain,
    BoxShape shape}) {
  String imageUrl = (url == null || url.length == 0)
      ? ""
      : ((url.startsWith("images") || url.startsWith("/"))
          ? (ApiConstants.imageBaseURL + url)
          : url);
  return new CachedNetworkImage(
    height: height,
    width: width,
    imageUrl: imageUrl,
    fit: fit,
    placeholder: (context, url) => Container(
      height: height,
      width: width,
      child: SpinKitFadingCircle(
        color: ColorConstants.colorPrimary,
        size: getSize(20),
      ),
    ),
    errorWidget: (context, url, error) => Image.asset(
      placeHolderImage == null || placeHolderImage.length == 0
          ? noAttachment
          : placeHolderImage,
      width: width,
      height: height,
      fit: fit,
    ),
  );
}
