import 'package:flutter/services.dart';

class Permisos {
  static const MethodChannel _channel = MethodChannel('channelUpdateKPI');

  static Future<bool> pedirPermisos() async {
    try {
      final result = await _channel.invokeMethod('validarPermisos');
      return result == 'Ok';
    } on PlatformException catch (e) {
      print("Error al pedir permisos: ${e.message}");
      return false;
    }
  }
}
