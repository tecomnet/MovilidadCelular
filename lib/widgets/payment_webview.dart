import 'package:flutter/material.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';
import 'package:movilidad_celulares/utils/retorno_pago.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Página de cobro de la pasarela.
///
/// Se cierra sola cuando la pasarela manda al cliente a la página de éxito o de
/// error, y devuelve ese [ResultadoPago] a quien la abrió.
class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  /// La página de cobro no cargó.
  ///
  /// Sin esto, un corte de red al abrir el checkout dejaba un cuadro blanco con
  /// la rueda girando para siempre: `isLoading` solo se apagaba en
  /// `onPageFinished`, que en un fallo no llega nunca. El cliente no tenía
  /// manera de saber si estaba esperando de más o si ya no iba a cargar.
  bool _fallo = false;

  /// Evita cerrar dos veces: el retorno puede llegar a la vez por
  /// onNavigationRequest y por onPageStarted, según cómo redirija la pasarela.
  bool _resuelto = false;

  /// Si [url] es una página de retorno, cierra con su resultado.
  ///
  /// Devuelve `true` cuando lo era, para impedir que se cargue: el cliente ve
  /// el aviso de la app en lugar de la página web.
  bool _atenderRetorno(String url) {
    final resultado = resultadoDeRetorno(url);
    if (resultado == null) return false;
    if (!_resuelto && mounted) {
      _resuelto = true;
      Navigator.of(context).pop(resultado);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // Sin zoom con los dedos.
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            // Algunas redirecciones no pasan por onNavigationRequest y solo se
            // ven aquí, cuando la página ya empezó a cargar.
            if (_atenderRetorno(url)) return;
            if (mounted) {
              setState(() {
                isLoading = true;
                _fallo = false;
              });
            }
          },
          onPageFinished: (url) {
            if (mounted) setState(() => isLoading = false);
          },
          onWebResourceError: (error) {
            // Solo importa el fallo de la página principal. Una imagen o un
            // script sueltos que no carguen no impiden pagar, y tratarlos como
            // error taparía un checkout que sí funciona.
            if (error.isForMainFrame == false) return;
            if (mounted) {
              setState(() {
                isLoading = false;
                _fallo = true;
              });
            }
          },
          onHttpError: (error) {
            if (error.response?.statusCode == null) return;
            if (mounted) {
              setState(() {
                isLoading = false;
                _fallo = true;
              });
            }
          },
          onNavigationRequest: (request) {
            return _atenderRetorno(request.url)
                ? NavigationDecision.prevent
                : NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            // Cerrar es volver a donde estaba, no ir a Inicio. Antes esta X
            // hacía pushNamedAndRemoveUntil('/home'), que además de llevárselo
            // a otra pantalla borraba toda la navegación: quien cancelaba desde
            // «Actualizar plan» perdía los pasos que ya había dado.
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
          if (_fallo) _pantallaDeFallo(),
        ],
      ),
    );
  }

  /// Tapa el cuadro en blanco cuando la página de cobro no carga.
  ///
  /// Se ofrece reintentar en la misma solicitud: la IdempotencyKey sigue viva,
  /// así que recargar aquí vuelve al mismo cobro y no genera uno nuevo.
  Widget _pantallaDeFallo() {
    return Container(
      color: TecomnetTheme.panelFondo,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 44,
            color: TecomnetTheme.tintaSuave,
          ),
          const SizedBox(height: 16),
          const Text(
            'No pudimos abrir la página de pago',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TecomnetTheme.tintaFuerte,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Revisa tu conexión e inténtalo de nuevo. '
            'Si ya te cobraron, no se volverá a cobrar.',
            textAlign: TextAlign.center,
            style: TextStyle(color: TecomnetTheme.tintaMedia, fontSize: 13.5),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _fallo = false;
                isLoading = true;
              });
              _controller.loadRequest(Uri.parse(widget.url));
            },
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
