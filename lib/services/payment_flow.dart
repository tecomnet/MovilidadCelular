import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';
import 'package:movilidad_celulares/utils/enums.dart';
import 'package:movilidad_celulares/utils/succes.dart';
import 'package:movilidad_celulares/widgets/payment_webview.dart';
import 'package:movilidad_celulares/widgets/tecomnet_widgets.dart';

/// Punto único del flujo de cobro.
///
/// Antes este bloque estaba repetido en inicio, recargar y actualizar plan, con
/// diferencias sutiles entre copias. Aquí vive una sola vez:
///
///   elegir método → registrar solicitud → abrir la página de cobro
///
/// El backend devuelve el `CheckoutUrl` ya listo, así que la app no habla con
/// la pasarela ni le manda el importe.
class PaymentFlow {
  PaymentFlow._();

  static bool _enCurso = false;

  /// ¿Hay un cobro abierto en este momento?
  ///
  /// Lo consulta el vigilante de inactividad de main.dart: pagar obliga a salir
  /// de la app —el SMS con el código, la app del banco— y el cierre por
  /// inactividad estaba matando el pago a los 5 minutos, devolviendo al cliente
  /// al login sin saber si le habían cobrado.
  static bool get enCurso => _enCurso;

  /// Lanza el cobro y espera a que termine.
  ///
  /// Devuelve [ResultadoPago.exitoso] o [ResultadoPago.error] cuando la
  /// pasarela manda al cliente a la página correspondiente, y `null` si no se
  /// llegó a cobrar o no se sabe cómo terminó (el cliente cerró la ventana, o
  /// el pago fue por QR y se completa fuera de la app).
  ///
  /// Los avisos se muestran aquí mismo; quien llama solo necesita ocuparse de
  /// su indicador de carga y, si quiere, de refrescar sus datos.
  static Future<ResultadoPago?> iniciar(
    BuildContext context, {
    required String iccid,
    required String msisdn,
    required int ofertaActualId,
    required int ofertaNuevaId,
    required double monto,
    required TipoOperacion operacion,
    int distribuidorId = 1,
  }) async {
    _enCurso = true;
    try {
      // 1. Registrar la solicitud (con reintentos e IdempotencyKey estable).
      //
      // No se pregunta la forma de pago. MetodoPagoID es un dato interno que
      // deja constancia de cómo acabó pagando el cliente, y eso lo resuelve la
      // pasarela: preguntarlo antes obligaba a elegir dos veces lo mismo, y la
      // respuesta de la app no era más que una suposición.
      //
      // Este paso puede tardar: son hasta 3 intentos con 20 s de espera cada uno.
      // Sin indicador el usuario ve la pantalla congelada, así que se bloquea con
      // un diálogo mientras dura.
      _mostrarEspera(context);

      final solicitud = await AuthService.registrarSolicitudDePago(
        iccid: iccid,
        msisdn: msisdn,
        ofertaActualId: ofertaActualId,
        ofertaNuevaId: ofertaNuevaId,
        monto: monto,
        tipoOperacion: tipoOperacionValue(operacion),
        canalVenta: canalDeVentaValue(CanalDeVenta.App),
        distribuidorId: distribuidorId,
      );

      if (!context.mounted) return null;
      _cerrarEspera(context);

      if (solicitud == null) {
        showNotice(context, 'No se pudo generar la solicitud de pago');
        return null;
      }

      // 2. Abrir el cobro. Según la forma de pago que elija el cliente ya en la
      //    pasarela, esta devuelve una página o un QR con la referencia.
      if (_texto(solicitud['CheckoutUrl']).isNotEmpty) {
        final resultado = await _abrirCheckout(context, solicitud);

        // 3. Cerrar el intento si terminó de verdad.
        //
        // La IdempotencyKey se guarda para que un reintento no genere un segundo
        // cobro, pero hasta ahora nadie la liberaba: quedaba viva 24 h y una
        // compra igual —misma SIM, misma oferta— reutilizaba la solicitud ya
        // pagada en vez de crear una nueva. El cliente que recargaba el mismo
        // paquete dos veces en el día se quedaba sin poder hacerlo.
        //
        // Solo se libera con un desenlace conocido. Si el cliente cerró la
        // ventana (null) se conserva a propósito: el cobro puede seguir su curso
        // y conviene volver a la misma solicitud, no abrir otra.
        if (resultado != null) {
          await AuthService.liberarIntento(
            iccid: iccid,
            ofertaNuevaId: ofertaNuevaId,
            tipoOperacion: tipoOperacionValue(operacion),
          );
        }
        return resultado;
      }
      if (_texto(solicitud['QrImageUrl']).isNotEmpty) {
        // El QR se paga fuera de la app, así que aquí no hay forma de saber el
        // resultado: se deja en null.
        _mostrarQr(context, solicitud);
        return null;
      }

      showNotice(context, 'No se recibió la página de pago');
      return null;
    } finally {
      _enCurso = false;
    }
  }

  /// Diálogo bloqueante mientras se prepara el cobro.
  ///
  /// No se puede descartar con el botón atrás: cancelarlo a medias dejaría una
  /// solicitud registrada en el servidor sin que el usuario llegue a pagarla.
  static void _mostrarEspera(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 18),
                  Text(
                    'Preparando tu pago…',
                    style: TextStyle(
                      color: TecomnetTheme.tintaFuerte,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void _cerrarEspera(BuildContext context) {
    if (!context.mounted) return;
    final navegador = Navigator.of(context, rootNavigator: true);
    if (navegador.canPop()) navegador.pop();
  }

  static Future<ResultadoPago?> _abrirCheckout(
    BuildContext context,
    Map<String, dynamic> solicitud,
  ) async {
    final resultado = await showDialog<ResultadoPago>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final pantalla = MediaQuery.of(dialogContext).size;
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: pantalla.width * 0.95,
            height: pantalla.height * 0.85,
            child: WebViewScreen(url: _texto(solicitud['CheckoutUrl'])),
          ),
        );
      },
    );

    if (!context.mounted) return resultado;

    switch (resultado) {
      case ResultadoPago.exitoso:
        // El aprovisionamiento no es instantáneo: se avisa de que puede tardar
        // para que el cliente no crea que falló si al volver aún no lo ve.
        showNotice(
          context,
          'Pago realizado. Puede tardar unos minutos en reflejarse.',
          color: TecomnetTheme.verde,
        );
      case ResultadoPago.error:
        showNotice(context, 'No se pudo completar el pago. Intenta de nuevo.');
      case null:
        // Cerró la ventana sin terminar: no se avisa nada, no sabemos cómo
        // quedó y un mensaje de error podría ser falso.
        break;
    }
    return resultado;
  }

  static void _mostrarQr(BuildContext context, Map<String, dynamic> solicitud) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Completa tu pago'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              _texto(solicitud['QrImageUrl']),
              height: 220,
              errorBuilder: (_, __, ___) => const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No se pudo cargar el código'),
              ),
            ),
            const SizedBox(height: 14),
            SelectableText(
              _texto(solicitud['OrderID']),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: TecomnetTheme.tintaMedia,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Listo'),
          ),
        ],
      ),
    );
  }
}

String _texto(dynamic v) => v?.toString() ?? '';
