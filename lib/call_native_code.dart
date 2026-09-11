import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform, debugPrint;
import 'package:flutter/services.dart';

/// Estado que devuelve el lado nativo al intentar arrancar el monitoreo.
enum EstadoMonitoreo {
  /// Registro en curso; el SDK arrancará al completarlo.
  registrando,

  /// El dispositivo ya estaba registrado y el monitoreo quedó activo.
  yaRegistrado,

  /// Faltan permisos mínimos: no se registró nada.
  faltanPermisos,

  /// No hay MSISDN ni privilegios de operador: registro pospuesto.
  faltaMsisdn,

  /// Plataforma sin SDK (iOS, web) o error de canal.
  noDisponible,
}

class CallNativeCode {
  static const platform = MethodChannel('channelUpdateKPI');

  /// Usa `defaultTargetPlatform` en vez de `dart:io`, que no está disponible
  /// en web y hacía fallar el arranque allí.
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static Future<String> callNativeInitialize() async {
    if (!isAndroid) return "";

    try {
      final data = await platform.invokeMethod('initializeOctolytics', {"arg": ""});
      debugPrint("[Flutter] Canal del SDK listo: $data");
      return data ?? "";
    } catch (e) {
      debugPrint("[Flutter] Error al inicializar el canal del SDK: $e");
      return "Failed";
    }
  }

  /// Entrega el MSISDN al SDK y dispara el registro y el arranque del monitoreo.
  ///
  /// Debe llamarse cuando el número ya se conoce: el registro ocurre aquí, no
  /// durante la solicitud de permisos. Antes esta llamada solo guardaba el
  /// número en una variable y el dispositivo ya había quedado registrado sin él.
  static Future<EstadoMonitoreo> iniciarMonitoreo(String msisdn) async {
    if (!isAndroid) return EstadoMonitoreo.noDisponible;

    try {
      final estado = await platform.invokeMethod<String>(
        'startServiceOctolytics',
        {"arg": msisdn},
      );
      debugPrint("[Flutter] Estado del monitoreo: $estado");
      switch (estado) {
        case 'REGISTERING':
          return EstadoMonitoreo.registrando;
        case 'ALREADY_REGISTERED':
          return EstadoMonitoreo.yaRegistrado;
        case 'PERMISSIONS_MISSING':
          return EstadoMonitoreo.faltanPermisos;
        case 'MSISDN_MISSING':
          return EstadoMonitoreo.faltaMsisdn;
        default:
          return EstadoMonitoreo.noDisponible;
      }
    } catch (e) {
      debugPrint("[Flutter] Error al iniciar el monitoreo: $e");
      return EstadoMonitoreo.noDisponible;
    }
  }

  static Future<bool> hasCarrierPrivileges() async {
    if (!isAndroid) return false;

    try {
      return await platform.invokeMethod<bool>('hasCarrierPrivileges') ?? false;
    } catch (e) {
      debugPrint("[Flutter] Error al consultar privilegios de operador: $e");
      return false;
    }
  }

  static Future<void> openHelp() async {
    if (!isAndroid) return;

    try {
      await platform.invokeMethod('launchHelpActivity');
    } catch (e) {
      debugPrint("[Flutter] No se pudo abrir HelpActivity: $e");
    }
  }

  static Future<void> openAddMsisdn() async {
    if (!isAndroid) return;

    try {
      await platform.invokeMethod('launchAddMsisdnActivity');
    } catch (e) {
      debugPrint("[Flutter] No se pudo abrir AddMsisdnActivity: $e");
    }
  }
}
