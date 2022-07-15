import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/Helper/Themehelper.dart';
import '../../app/constant/ColorConstant.dart';
import '../../utils/appLifeCycle.dart';
import 'Leaderboard/Leaderboard.dart';

class PermissionScreen extends StatefulWidget {
  static const route = "PermissionScreen";

  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(LifecycleEventHandler(
        detachedCallBack: () {},
        resumeCallBack: () {
          permissionHandler();
        },
        context: context));
    permissionHandler();
    // TODO: implement initState
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(LifecycleEventHandler(
        detachedCallBack: () {},
        resumeCallBack: () {
          permissionHandler();
        },
        context: context));
  }

  permissionHandler() async {
    var camStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;
    if (camStatus.isGranted == true && microphoneStatus.isGranted == true) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => LeaderBoard()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: ColorConstants.mainBgColor,
        body: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(),
              ),
              Text('Camera and microphone permission are required',
                  style: appTheme?.white14Bold),
              SizedBox(
                height: 5.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: ColorConstants.red, // background
                ),
                onPressed: () async {
                  await openAppSettings();
                },
                child: Text("Open settings"),
              ),
              Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
