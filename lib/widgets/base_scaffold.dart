import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movilidad_celulares/call_native_code.dart';
import 'package:url_launcher/url_launcher.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool centerTitle;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const BaseScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.centerTitle = true,
    this.scaffoldKey,
  }) : super(key: key);

  void _navigate(
    BuildContext context,
    String routeName, {
    bool clearStack = false,
  }) {
    Navigator.pop(context);

    if (clearStack) {
      Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routeName,
        (route) => route.settings.name == '/home',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(title),
        centerTitle: centerTitle,
        actions: [
          Transform.translate(
            offset: const Offset(0, 4),
            child: IconButton(
              icon: const Icon(Icons.phone),
              tooltip: 'Llamar',
              onPressed: () async {
                const phoneNumber = 'tel:5597297420';
                if (await canLaunchUrl(Uri.parse(phoneNumber))) {
                  await launchUrl(Uri.parse(phoneNumber));
                } else {
                  print('No se pudo abrir el marcador');
                }
              },
            ),
          ),
          Transform.translate(
            offset: const Offset(0, 4),
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.whatsapp),
              tooltip: 'WhatsApp',
              onPressed: () async {
                final whatsappNumber = '+525524941739';
                final whatsappUrl = Uri.parse(
                  'https://wa.me/$whatsappNumber?text=Hola%20quiero%20informes',
                );
                if (await canLaunchUrl(whatsappUrl)) {
                  await launchUrl(
                    whatsappUrl,
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  print('No se pudo abrir WhatsApp');
                }
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Imagenes/Logo.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black),
              title: const Text(
                'Inicio',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.autorenew, color: Colors.black),
              title: const Text(
                'Actualizar plan',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () => _navigate(context, '/redirect'),
            ),
            ListTile(
              leading: const Icon(
                Icons.people_alt_rounded,
                color: Colors.black,
              ),
              title: const Text(
                'Mi perfil',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: ListTile(
                leading: const Icon(
                  Icons.phone_android,
                  size: 20,
                  color: Colors.black,
                ),
                title: const Text(
                  'Ver recargas',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                onTap: () => _navigate(context, '/refills'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: ListTile(
                leading: const Icon(
                  Icons.people_outline_sharp,
                  size: 20,
                  color: Colors.black,
                ),
                title: const Text(
                  'Mi perfil',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                onTap: () => _navigate(context, '/profile'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: ListTile(
                leading: const Icon(
                  Icons.lock_reset,
                  size: 20,
                  color: Colors.black,
                ),
                title: const Text(
                  'Cambiar Contraseña',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                onTap: () => _navigate(context, '/changePassword'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.black),
              title: const Text(
                'Abrir Diagnóstico',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              onTap: () => CallNativeCode.openHelp(),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text('Salir', style: TextStyle(color: Colors.black)),
              onTap: () async {
                final shouldExit = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("¿Deseas cerrar sesión y salir?"),                    
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Salir"),
                      ),
                    ],
                  ),
                );

                if (shouldExit ?? false) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
