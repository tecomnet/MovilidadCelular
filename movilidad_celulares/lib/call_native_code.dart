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
      final data = await platform.invokeMethod('validarPermisos', {"arg": ""});
      return data;
    } on PlatformException catch (_) {
      return "Failed";
    }
  }

  static Future<String> callNativeFunctionStartService(String msisdn) async {
  if (io.Platform.isIOS) return "";

  try {
    final result = await platform.invokeMethod('startServiceOctolytics', {"arg": msisdn});
    print("[Flutter] Resultado iniciar servicio: $result");
    return result;
  } on PlatformException catch (e) {
    print("[Flutter] Error al iniciar servicio: ${e.message}");
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
  static Future<bool> hasCarrierPrivileges() async {
  try {
    final bool result = await platform.invokeMethod('hasCarrierPrivileges');
    return result;
  } on PlatformException {
    return false;
  }
}
Future<String> iniciarServicioOctopulse(String msisdn) async {
  final bool tienePrivilegios = await CallNativeCode.hasCarrierPrivileges();
  print("[Flutter] Tiene privilegios: $tienePrivilegios");

  final String resultado = await CallNativeCode.callNativeFunctionStartService(msisdn);
  print("[Flutter] Resultado iniciar servicio: $resultado");
  return resultado;
}

 static Future<bool> checkOptionalPermissions() async {
    
    try {
      return await platform.invokeMethod('checkOptionalPermissions');
    } on PlatformException catch (e) {
      print("Error checking optional permissions: ${e.message}");
      return false;
    }
  }
   static Future<void> requestOptionalPermissions() async {
    
    try {
      await platform.invokeMethod('requestOptionalPermissions');
    } on PlatformException catch (e) {
      print("Error requesting optional permissions: ${e.message}");
    }
  }

}
