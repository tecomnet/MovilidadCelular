import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:movilidad_celulares/screens/success_screen.dart';

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
             if (widget.redirectUrl != null && request.url == widget.redirectUrl) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SuccessScreen()),
    );
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
