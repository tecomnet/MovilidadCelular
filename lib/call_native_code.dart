import 'dart:io' as io;
import 'package:flutter/services.dart';

class CallNativeCode {
  static const platform = MethodChannel('channelUpdateKPI');

  static bool get isAndroid => io.Platform.isAndroid;

  static Future<String> callNativeInitialize() async {
    if (!isAndroid) return "";

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
    if (!isAndroid) return "";

    try {
      final data = await platform.invokeMethod('validarPermisos', {"arg": ""});
      return data;
    } on PlatformException catch (_) {
      return "Failed";
    }
  }

  static Future<String> callNativeFunctionStartService(String msisdn) async {
    if (!isAndroid) return "";

    try {
      final result = await platform.invokeMethod('startServiceOctolytics', {"arg": msisdn});
      print("[Flutter] Resultado iniciar servicio: $result");
      return result;
    } on PlatformException catch (e) {
      print("[Flutter] Error al iniciar servicio: ${e.message}");
      return "Failed";
    }
  }

  static Future<void> showInterface(String msisdn) async {
    if (!isAndroid) return;

    try {
      await platform.invokeMethod('showInterface', {"arg": msisdn});
    } on PlatformException catch (_) {
      print("[Flutter] Error al mostrar interfaz");
    }
  }

  static Future<void> openHelp() async {
    if (!isAndroid) return;

    try {
      await platform.invokeMethod('launchHelpActivity');
    } on PlatformException catch (e) {
      print("Failed to open HelpActivity: '${e.message}'");
    }
  }

  static Future<void> openAddMsisdn() async {
    if (!isAndroid) return;

    try {
      await platform.invokeMethod('launchAddMsisdnActivity');
    } on PlatformException catch (e) {
      print("Failed to open AddMsisdnActivity: '${e.message}'");
    }
  }

  static Future<bool> hasCarrierPrivileges() async {
    if (!isAndroid) return false;

    try {
      final bool result = await platform.invokeMethod('hasCarrierPrivileges');
      return result;
    } on PlatformException {
      return false;
    }
  }

  static Future<String> iniciarServicioOctopulse(String msisdn) async {
    if (!isAndroid) return "";

    final bool tienePrivilegios = await hasCarrierPrivileges();
    print("[Flutter] Tiene privilegios: $tienePrivilegios");

    final String resultado = await callNativeFunctionStartService(msisdn);
    print("[Flutter] Resultado iniciar servicio: $resultado");
    return resultado;
  }

  static Future<bool> checkOptionalPermissions() async {
    if (!isAndroid) return false;

    try {
      return await platform.invokeMethod('checkOptionalPermissions');
    } on PlatformException catch (e) {
      print("Error checking optional permissions: ${e.message}");
      return false;
    }
  }

  static Future<void> requestOptionalPermissions() async {
    if (!isAndroid) return;

    try {
      await platform.invokeMethod('requestOptionalPermissions');
    } on PlatformException catch (e) {
      print("Error requesting optional permissions: ${e.message}");
    }
  }
}