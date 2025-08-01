import 'dart:io' as io;
import 'package:flutter/services.dart';

class CallNativeCode {
  static const platform = MethodChannel('channelUpdateKPI');

  static Future<String> callNativeInitialize() async {
    if (io.Platform.isIOS) return "";

    try {
      final data = await platform.invokeMethod('initializeOctolytics', {"arg": ""});
      print("[Flutter] Permisos nativos solicitados, resultado: $data");
      return data;
    } on PlatformException catch (_) {
      print("[Flutter] Error al pedir permisos");
      return "Failed";
    }
  }

  static Future<String> callNativePermission() async {
    if (io.Platform.isIOS) return "";

    try {
      final data = await platform.invokeMethod('validPermission', {"arg": ""});
      return data;
    } on PlatformException catch (_) {
      return "Failed";
    }
  }

  static Future<String> callNativeFunctionStarService(String _msisdn) async {
    if (io.Platform.isIOS) return "";

    try {
      final data = await platform.invokeMethod('startServiceOctolytics', {"arg": _msisdn});
      return data;
    } on PlatformException catch (_) {
      return "Failed";
    }
  }

  static Future<void> showInterface(String _msisdn) async {
    try {
      await platform.invokeMethod('showInterface', {"arg": _msisdn});
    } on PlatformException catch (_) {
      print("[Flutter] Error al mostrar interfaz");
    }
  }

  static Future<void> openHelp() async {
    try {
      await platform.invokeMethod('launchHelpActivity');
    } on PlatformException catch (e) {
      print("Failed to open HelpActivity: '${e.message}'");
    }
  }

  static Future<void> openAddMsisdn() async {
    try {
      await platform.invokeMethod('launchAddMsisdnActivity');
    } on PlatformException catch (e) {
      print("Failed to open AddMsisdnActivity: '${e.message}'");
    }
  }
}
