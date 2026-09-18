import 'dart:math';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';

/// Genera y conserva la `IdempotencyKey` de una intención de compra.
///
/// El contrato de `RegistrarSolicitudDePago` exige una clave que identifique el
/// intento. Si una llamada se va en timeout no sabemos si el servidor la
/// registró o no; reintentando con **la misma clave** el servidor reconoce el
/// intento y devuelve la solicitud original en vez de crear una segunda. Por
/// eso la clave se genera una sola vez por intento y se guarda en disco: si la
/// app se cierra a mitad del pago, al volver se reutiliza en lugar de abrir un
/// cobro nuevo.
///
/// La clave se libera con [liberar] cuando el intento termina, para que la
/// siguiente compra empiece con una nueva.
class Idempotency {
  Idempotency._();

  static const String _prefijo = 'idem:';

  /// Identifica la intención: misma SIM, misma oferta y misma operación son el
  /// mismo intento mientras no se complete.
  static String _clave({
    required String iccid,
    required String ofertaNuevaId,
    required int tipoOperacion,
  }) => '$_prefijo$iccid|$ofertaNuevaId|$tipoOperacion';

  /// UUID v4 con `Random.secure`, sin dependencias externas.
  static String nuevoUuid() {
    final aleatorio = Random.secure();
    final bytes = List<int>.generate(16, (_) => aleatorio.nextInt(256));

    bytes[6] = (bytes[6] & 0x0f) | 0x40; // versión 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variante RFC 4122

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }

  /// Devuelve la clave del intento en curso, creándola solo si no existía.
  ///
  /// Llamar dos veces para la misma intención devuelve **la misma** clave: es
  /// justo lo que permite reintentar sin duplicar el cobro.
  static Future<String> obtener({
    required String iccid,
    required String ofertaNuevaId,
    required int tipoOperacion,
  }) async {
    final clave = _clave(
      iccid: iccid,
      ofertaNuevaId: ofertaNuevaId,
      tipoOperacion: tipoOperacion,
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final guardada = prefs.getString(clave);
      final vigente = _vigente(guardada);
      if (vigente != null) {
        if (kDebugMode) debugPrint('🔁 Reutilizando IdempotencyKey: $vigente');
        return vigente;
      }

      final nueva = nuevoUuid();
      final ahora = DateTime.now().millisecondsSinceEpoch;
      await prefs.setString(clave, '$nueva|$ahora');
      if (kDebugMode) debugPrint('🆕 IdempotencyKey generada: $nueva');
      return nueva;
    } catch (e) {
      // Si el almacenamiento falla preferimos seguir con una clave en memoria
      // antes que bloquear el pago; se pierde la protección entre arranques,
      // no dentro del mismo intento.
      if (kDebugMode) debugPrint('⚠️ No se pudo guardar la IdempotencyKey: $e');
      return nuevoUuid();
    }
  }

  /// Cuánto vale una clave antes de darla por vencida.
  ///
  /// Existe para que un reintento no genere un segundo cobro, y los reintentos
  /// ocurren en minutos. Sin caducidad, una clave de hace días se seguía
  /// mandando: si el servidor se atasca con ella, esa compra queda bloqueada
  /// para siempre en ese teléfono y desde la app no hay manera de salir. Pasó
  /// de verdad, y hubo que borrarla a mano por adb.
  static const Duration _vigencia = Duration(hours: 24);

  /// La clave guardada si aún sirve, o `null` si venció o tiene formato viejo.
  ///
  /// Las guardadas antes de existir la marca de tiempo no la llevan, así que
  /// caen por aquí y se sustituyen solas en el siguiente intento.
  static String? _vigente(String? guardada) {
    if (guardada == null || guardada.isEmpty) return null;

    final partes = guardada.split('|');
    if (partes.length != 2) return null;

    final marca = int.tryParse(partes[1]);
    if (marca == null) return null;

    final edad = DateTime.now().millisecondsSinceEpoch - marca;
    if (edad < 0 || edad > _vigencia.inMilliseconds) return null;

    return partes.first;
  }

  /// Cierra el intento. A partir de aquí, una compra igual usará clave nueva.
  ///
  /// Debe llamarse cuando el intento termina de verdad: pago confirmado, o
  /// rechazo definitivo. **No** al abandonar el WebView, porque el cobro puede
  /// seguir su curso y querríamos volver a la misma solicitud.
  static Future<void> liberar({
    required String iccid,
    required String ofertaNuevaId,
    required int tipoOperacion,
  }) async {
    final clave = _clave(
      iccid: iccid,
      ofertaNuevaId: ofertaNuevaId,
      tipoOperacion: tipoOperacion,
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(clave);
      if (kDebugMode) debugPrint('✅ IdempotencyKey liberada');
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ No se pudo liberar la IdempotencyKey: $e');
    }
  }
}
