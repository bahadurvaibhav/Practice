import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack});

  final AsyncCallback resumeCallBack;

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.suspending:
        break;
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
    }
  }
}