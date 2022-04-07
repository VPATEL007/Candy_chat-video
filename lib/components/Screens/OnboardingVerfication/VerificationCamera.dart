import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/math_utils.dart';

class VerificationCamera extends StatefulWidget {
  static const route = "VerificationCamera";
  final Function(XFile)? imageCapture;
  VerificationCamera({Key? key, this.imageCapture}) : super(key: key);

  @override
  State<VerificationCamera> createState() => _VerificationCameraState();
}

class _VerificationCameraState extends State<VerificationCamera> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  XFile? imageFile;

  @override
  void initState() {
    super.initState();

    intialiseCamera();
  }

  intialiseCamera() async {
    await [Permission.camera].request();
    cameras = await availableCameras();

    controller = CameraController(cameras[1], ResolutionPreset.max);

    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: SafeArea(
          child: Stack(
            children: [
              controller?.value.isInitialized == true
                  ? CameraPreview(controller!)
                  : Container(),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(getSize(16)),
                  child: Container(
                    child: Image.asset(icVerificationExam),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(getSize(16)),
                    child: Container(
                      child: Image.asset(icClose),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  icVerification,
                  height: MathUtilities.screenWidth(context) - getSize(60),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {},
                  child: InkWell(
                    onTap: () {
                      controller?.takePicture().then((XFile? file) {
                        if (mounted) {
                          imageFile = file;
                          widget.imageCapture!(imageFile!);
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: Container(
                      child: Image.asset(icCapture),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
