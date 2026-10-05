import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:movilidad_celulares/utils/session_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movilidad_celulares/call_native_code.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// Armazón del panel: barra superior clara y cajón lateral oscuro.
///
/// El cajón es la versión móvil del sidebar del portal web: mismo orden de
/// secciones, mismo bloque de usuario al pie.
class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool centerTitle;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// Ruta activa, para resaltarla en el cajón (p. ej. '/home').
  final String? rutaActual;

  const BaseScaffold({
    super.key,
    required this.title,
    required this.body,
    this.centerTitle = false,
    this.scaffoldKey,
    this.rutaActual,
  });

  static const String _telefono = 'tel:5597297420';
  static const String _whatsapp = '+525524941739';

  Future<void> _abrir(Uri uri, {LaunchMode? modo}) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: modo ?? LaunchMode.platformDefault);
    } else {
      if (kDebugMode) debugPrint('No se pudo abrir $uri');
    }
  }

  void _navegar(BuildContext context, String ruta) {
    Navigator.pop(context); // cierra el cajón
    if (ruta == rutaActual) return;

    if (ruta == '/home') {
      Navigator.pushNamedAndRemoveUntil(context, ruta, (r) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        ruta,
        (r) => r.settings.name == '/home',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Barra de navegación transparente e iconos oscuros, porque el fondo de
    // estas pantallas es claro. La barra de estado la sigue decidiendo el
    // AppBar: Flutter toma el estilo de arriba del AppBar y el de abajo de aquí.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: _armazon(context),
    );
  }

  Widget _armazon(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: TecomnetTheme.panelFondo,
      appBar: AppBar(
        backgroundColor: TecomnetTheme.panelBarra,
        surfaceTintColor: TecomnetTheme.panelBarra,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: centerTitle,
        iconTheme: const IconThemeData(color: TecomnetTheme.tintaFuerte),
        title: Text(
          title,
          style: const TextStyle(
            color: TecomnetTheme.tintaFuerte,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined),
            tooltip: 'Llamar a soporte',
            color: TecomnetTheme.tintaMedia,
            onPressed: () => _abrir(Uri.parse(_telefono)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 2),
            child: _botonWhatsapp(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: TecomnetTheme.panelBorde),
        ),
      ),
      drawer: _cajon(context),
      // De borde a borde, el contenido llega hasta debajo de la barra de
      // navegación. Arriba ya protege el AppBar; esto cubre abajo y los lados.
      // Hace falta porque las listas de las pantallas llevan un padding fijo,
      // que anula el relleno que Flutter añadiría solo para el sistema.
      body: SafeArea(top: false, child: body),
    );
  }

  Widget _botonWhatsapp() {
    return Material(
      color: TecomnetTheme.whatsapp,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => _abrir(
          Uri.parse('https://wa.me/$_whatsapp?text=Hola%20quiero%20informes'),
          modo: LaunchMode.externalApplication,
        ),
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.whatsapp,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cajon(BuildContext context) {
    return Drawer(
      backgroundColor: TecomnetTheme.cajonFondo,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Image.asset(
                'assets/Imagenes/Logo.png',
                height: 76,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(height: 8),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _item(context, Icons.home_outlined, 'Inicio', '/home'),
                  _item(context, Icons.bolt_outlined, 'Recargar', '/recargar'),
                  _item(
                    context,
                    Icons.autorenew_rounded,
                    'Actualizar plan',
                    '/actualizarPlan',
                  ),
                  const _Seccion('MI CUENTA'),
                  _item(
                    context,
                    Icons.receipt_long_outlined,
                    'Mis recargas',
                    '/refills',
                  ),
                  // Agregar tarjeta se abre desde aquí: la lista es la que
                  // hace falta para poder quitarlas.
                  _item(
                    context,
                    Icons.credit_card_outlined,
                    'Mis tarjetas',
                    '/cards',
                  ),
                  _item(
                    context,
                    Icons.person_outline_rounded,
                    'Mi perfil',
                    '/profile',
                  ),
                  _item(
                    context,
                    Icons.key_outlined,
                    'Cambiar contraseña',
                    '/changePassword',
                  ),
                  // El diagnóstico lo abre el SDK de Octopulse, que solo existe
                  // en Android. En iOS la opción no se muestra: tocarla no
                  // haría nada y el cliente creería que la app está rota.
                  if (CallNativeCode.isAndroid) ...[
                    const _Seccion('SOPORTE'),
                    _item(
                      context,
                      Icons.speed_rounded,
                      'Diagnóstico de red',
                      null,
                      alTocar: () {
                        Navigator.pop(context);
                        CallNativeCode.openHelp();
                      },
                    ),
                  ],
                ],
              ),
            ),
            _bloqueUsuario(),
            _salir(context),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icono,
    String texto,
    String? ruta, {
    VoidCallback? alTocar,
  }) {
    final activo = ruta != null && ruta == rutaActual;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: activo ? TecomnetTheme.cajonActivo : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap:
              alTocar ?? (ruta == null ? null : () => _navegar(context, ruta)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(
                  icono,
                  size: 21,
                  color: activo ? Colors.white : TecomnetTheme.cajonTexto,
                ),
                const SizedBox(width: 14),
                Text(
                  texto,
                  style: TextStyle(
                    color: activo ? Colors.white : TecomnetTheme.cajonTexto,
                    fontSize: 15,
                    fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bloqueUsuario() {
    final correo = AuthService.email ?? '';
    final inicial = correo.isNotEmpty ? correo[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: TecomnetTheme.cajonActivo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: TecomnetTheme.azulClaro,
            child: Text(
              inicial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              correo.isEmpty ? 'Sesión activa' : correo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: TecomnetTheme.cajonTexto,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _salir(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            final salir = await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                backgroundColor: TecomnetTheme.tarjeta,
                title: const Text(
                  '¿Deseas cerrar sesión y salir?',
                  style: TextStyle(
                    color: TecomnetTheme.textoPrincipal,
                    fontSize: 18,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: TecomnetTheme.textoSecundario),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: const Text(
                      'Salir',
                      style: TextStyle(color: TecomnetTheme.cian),
                    ),
                  ),
                ],
              ),
            );

            if (salir != true) return;
            await SessionManager.logout();
            AuthService.cerrarSesion();
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  size: 21,
                  color: TecomnetTheme.cajonTexto,
                ),
                SizedBox(width: 14),
                Text(
                  'Salir',
                  style: TextStyle(
                    color: TecomnetTheme.cajonTexto,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final String texto;
  const _Seccion(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 22, 14, 8),
      child: Text(
        texto,
        style: const TextStyle(
          color: TecomnetTheme.cajonTextoTenue,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.8,
        ),
      ),
    );
  }
}
