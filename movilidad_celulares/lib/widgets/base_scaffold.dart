import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movilidad_celulares/call_native_code.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool centerTitle;

  const BaseScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.centerTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: centerTitle,
        actions: [
          Transform.translate(
            offset: const Offset(0, 4), // mueve hacia abajo
            child: IconButton(
              icon: const Icon(Icons.phone),
              tooltip: 'Llamar',
              onPressed: () {},
            ),
          ),
          Transform.translate(
            offset: const Offset(0, 4),
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.whatsapp),
              tooltip: 'WhatsApp',
              onPressed: () async {},
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
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.black),
              title: const Text(
                'Quiero más datos',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/moreData');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black),
              title: const Text(
                'Mi perfil',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () => Navigator.pop(context),
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
                onTap: () {
                  Navigator.pushNamed(context, '/refills');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.black,
                ),
                title: const Text(
                  'Mi perfil',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
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
                onTap: () {
                  Navigator.pushNamed(context, '/changePassword');
                },
              ),
            ),

            ListTile(
              leading: const Icon(Icons.sim_card, color: Colors.black),
              title: const Text(
                'Registrar MSISDN',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              onTap: () => CallNativeCode.openAddMsisdn(),
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
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
