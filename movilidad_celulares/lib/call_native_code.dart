import 'dart:io' as io;
import 'package:flutter/services.dart';

class CallNativeCode {
  static const platform = MethodChannel('channelUpdateKPI');
  String receivedString = "";

  static Future<String> callNativeInitialize() async {
    if (io.Platform.isIOS) {
      return "";
    }
    String data = "";
    try {
      data = await platform.invokeMethod('initializeOctolytics', {"arg": ""});
       print("[Flutter] Permisos nativos solicitados, resultado: $data");
    } on PlatformException catch (_) {
      data = "Failed";
       print("[Flutter] Error al pedir permisos");
    }
    return data;
  }

  static Future<String> callNativePermission() async {
    if (io.Platform.isIOS) {
      return "";
    }
    String data = "";
    try {
      data = await platform.invokeMethod('validPermission', {"arg": ""});
    } on PlatformException catch (_) {
      data = "Failed";
    }
    return data;
  }

  static Future<String> callNativeFunctionStarService(_msisdn) async {
    if (io.Platform.isIOS) {
      return "";
    }
    String data = "";
    try {
      data = await platform.invokeMethod(
        'startServiceOctolytics',
        {"arg": _msisdn},
      );
    } on PlatformException catch (_) {
      data = "Failed";
    }
    return data;
  }

  static Future<void> showInterface(_msisdn) async {
    String data = "-";
    try {
      data = await platform.invokeMethod('showInterface', {"arg": _msisdn});
    } on PlatformException catch (_) {
      data = "Failed";
    }
  }
  static Future<void> openHelp() async {
    try {
      await platform.invokeMethod('launchHelpActivity');
    } on PlatformException catch (e) {
      print("Failed to open HelpActivity: '${e.message}'.");
    }
  }

  static Future<void> openAddMsisdn() async {
    try {
      await platform.invokeMethod('launchAddMsisdnActivity');
    } on PlatformException catch (e) {
      print("Failed to open AddMsisdnActivity: '${e.message}'.");
    }
  }
}