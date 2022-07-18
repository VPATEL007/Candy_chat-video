import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({required this.resumeCallBack, required this.detachedCallBack, required this.pausedCallback, this.context});

  var context;
  final Function resumeCallBack;
  final Function detachedCallBack;
  final Function pausedCallback;


  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        pausedCallback();
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.resumed:
        resumeCallBack();
        print('AppLifecycleState.resumed called');
        break;
    }
  }
}