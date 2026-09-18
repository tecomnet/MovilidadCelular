import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/services.dart';

/// Oculta la pantalla actual a capturas, grabaciones y a la vista de apps
/// recientes, mientras muestra datos sensibles como una tarjeta.
///
/// Usa FLAG_SECURE en Android. En iOS no existe esa bandera y protegerlo
/// requiere código nativo propio, así que ahí no hace nada.
class PantallaSegura {
  PantallaSegura._();

  static const MethodChannel _canal = MethodChannel('tecomnet/pantalla_segura');

  static bool get _esAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static Future<void> activar() => _invocar('activar');

  static Future<void> desactivar() => _invocar('desactivar');

  static Future<void> _invocar(String metodo) async {
    if (!_esAndroid) return;
    try {
      await _canal.invokeMethod<void>(metodo);
    } catch (_) {
      // Si falla, la pantalla sigue funcionando; solo pierde la protección.
    }
  }
}
