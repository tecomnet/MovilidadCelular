import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String? redirectUrl;

  const WebViewScreen({super.key, required this.url, this.redirectUrl});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  /// ¿Esta navegación es el regreso del pago?
  ///
  /// Se ignoran los parámetros de consulta y se compara `origen + ruta`, porque
  /// la pasarela añade los suyos al devolver al usuario. Antes se exigía
  /// igualdad exacta de toda la cadena y bastaba un parámetro extra para que el
  /// regreso pasara desapercibido.
  bool _esUrlDeRetorno(String url) {
    final esperada = widget.redirectUrl;
    if (esperada == null || esperada.isEmpty) return false;

    final actual = Uri.tryParse(url);
    final objetivo = Uri.tryParse(esperada);
    if (actual == null || objetivo == null) return false;

    return actual.origin == objetivo.origin && actual.path == objetivo.path;
  }

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            // Se compara por prefijo, no por igualdad exacta: la pasarela añade
            // sus propios parámetros al devolver al usuario, y con `==` el
            // regreso no se detectaba nunca.
            if (_esUrlDeRetorno(request.url)) {
              // Se cierra el diálogo del pago sin llegar a cargar la página de
              // retorno: la app vuelve a donde estaba el usuario.
              Navigator.of(context).pop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
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
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/home', (route) => false);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
