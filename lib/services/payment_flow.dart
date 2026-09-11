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

  /// Lanza el cobro. Devuelve `true` si se llegó a abrir la página de pago.
  ///
  /// Los avisos de error se muestran aquí mismo; quien llama solo necesita
  /// ocuparse de su indicador de carga.
  static Future<bool> iniciar(
    BuildContext context, {
    required String iccid,
    required String msisdn,
    required int ofertaActualId,
    required int ofertaNuevaId,
    required double monto,
    required TipoOperacion operacion,
    int distribuidorId = 1,
  }) async {
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

    if (!context.mounted) return false;
    _cerrarEspera(context);

    if (solicitud == null) {
      showNotice(context, 'No se pudo generar la solicitud de pago');
      return false;
    }

    // 2. Abrir el cobro. Según la forma de pago que elija el cliente ya en la
    //    pasarela, esta devuelve una página o un QR con la referencia.
    if (_texto(solicitud['CheckoutUrl']).isNotEmpty) {
      _abrirCheckout(context, solicitud);
      return true;
    }
    if (_texto(solicitud['QrImageUrl']).isNotEmpty) {
      _mostrarQr(context, solicitud);
      return true;
    }

    showNotice(context, 'No se recibió la página de pago');
    return false;
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

  static void _abrirCheckout(
    BuildContext context,
    Map<String, dynamic> solicitud,
  ) {
    final urlRetorno = generarUrlRetorno(_texto(solicitud['OrderID']));

    showDialog(
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
            child: WebViewScreen(
              url: _texto(solicitud['CheckoutUrl']),
              redirectUrl: urlRetorno,
            ),
          ),
        );
      },
    );
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
