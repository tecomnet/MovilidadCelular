import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform, debugPrint;
import 'package:flutter/services.dart';

class Permisos {
  static const MethodChannel _channel = MethodChannel('channelUpdateKPI');

  static bool get _esAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Solicita los permisos mínimos que necesita el SDK de monitoreo.
  ///
  /// Devuelve el resultado real de la decisión del usuario. Antes comparaba
  /// contra la cadena 'Ok', que el lado nativo respondía siempre, por lo que
  /// esta función nunca devolvía false.
  static Future<bool> pedirPermisos() async {
    // Solo Android tiene el SDK integrado. En iOS y web no hay nada que pedir.
    if (!_esAndroid) return true;

    try {
      final result = await _channel.invokeMethod<bool>('validarPermisos');
      return result ?? false;
    } catch (e) {
      debugPrint('Error al pedir permisos: $e');
      return false;
    }
  }
}
