
// import 'package:flutter_files_picker/flutter_files_picker.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// Future openImagePicker(
//     BuildContext context, Function getImage(File file)) async {
//   FocusScope.of(context).unfocus();
//   await FlutterFilePicker.pickImage(
//     onFileSelect: (fileArray) {
//       if (fileArray != null && fileArray.length > 0) {
//         File _imageFile = File(fileArray[0].fileUrl);
//         var fileSize = _imageFile.lengthSync() / 1024;
//         if (fileSize > IMAGE_FILE_SIZE * 1024) {
//           Fluttertoast.showToast(msg: "File size must be less than 10 Mb");
//           return null;
//         } else {
//           getImage(_imageFile);
//         }
//       }
//     },
//   );
// }

// Future openVideoPicker(
//     BuildContext context, Function getImage(File file)) async {
//   FocusScope.of(context).unfocus();
//   await FlutterFilePicker.pickVideo(
//     onFileSelect: (fileArray) {
//       if (fileArray != null && fileArray.length > 0) {
//         File _imageFile = File(fileArray[0].fileUrl);
//         var fileSize = _imageFile.lengthSync() / 1024;
//         if (fileSize > IMAGE_FILE_SIZE * 1024) {
//           Fluttertoast.showToast(msg: "File size must be less than 10 Mb");
//           return null;
//         } else {
//           getImage(_imageFile);
//         }
//       }
//     },
//   );
// }
