import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils{
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