import 'dart:io';
import 'package:flutter/services.dart';

class Permisos {
  static const MethodChannel _channel = MethodChannel('channelUpdateKPI');

  static Future<bool> pedirPermisos() async {
    if (Platform.isIOS) return true;

    try {
      final result = await _channel.invokeMethod('validarPermisos');
      return result == 'Ok';
    } catch (e) {
      print("Error al pedir permisos: $e");
      return false;
    }
  }
}