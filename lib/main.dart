import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_strategy/url_strategy.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';
import 'package:movilidad_celulares/call_native_code.dart';
import 'package:movilidad_celulares/utils/session_manager.dart';

import 'package:movilidad_celulares/screens/change_password.dart';
import 'package:movilidad_celulares/screens/forgot_password.dart';
import 'package:movilidad_celulares/screens/profile_screen.dart';
import 'package:movilidad_celulares/screens/update_plan_screen.dart';
import 'package:movilidad_celulares/screens/menu_screen.dart';
import 'package:movilidad_celulares/screens/refills_screen.dart';
import 'package:movilidad_celulares/widgets/tecomnet_widgets.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  AuthService.alCaducarSesion = _volverAlLogin;

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      if (kIsWeb) {
        setPathUrlStrategy();
      } else {
        await CallNativeCode.callNativeInitialize();
      }

      // No se restaura la sesión al arrancar: el token vive solo en memoria y
      // caduca a los 60 minutos, así que reabrir la app siempre pasa por el
      // login. Antes se leía isLoggedIn() y se pasaba a MyApp, que nunca lo
      // usaba —initialRoute era '/login' siempre—, de modo que el dato daba a
      // entender una restauración que no existía.
      runApp(const SessionWatcher(child: MyApp()));
    },
    (error, stackTrace) {
      debugPrint("❌ Error en la app: $error");
    },
  );
}

/// Cierra la sesión y vuelve al login diciendo por qué.
///
/// Sin esto, un token caducado se veía como «no se pudo generar la solicitud de
/// pago» o como una pantalla sin líneas: el usuario no tenía manera de saber
/// que lo que había que hacer era volver a entrar.
Future<void> _volverAlLogin() async {
  await SessionManager.logout();
  navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (r) => false);

  // El aviso va después del fotograma: antes de eso el login todavía no está
  // montado y no hay ScaffoldMessenger al que colgarlo.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final contexto = navigatorKey.currentContext;
    if (contexto != null) {
      showNotice(contexto, 'Tu sesión expiró. Vuelve a iniciar sesión.');
    }
  });
}

class SessionWatcher extends StatefulWidget {
  final Widget child;
  const SessionWatcher({super.key, required this.child});

  @override
  State<SessionWatcher> createState() => _SessionWatcherState();
}

class _SessionWatcherState extends State<SessionWatcher>
    with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _timer?.cancel();
      _timer = Timer(const Duration(minutes: 5), _handleTimeout);
    } else if (state == AppLifecycleState.resumed) {
      _timer?.cancel();
    }
  }

  Future<void> _handleTimeout() async {
    await SessionManager.logout();

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Movilidad Celulares',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Sin esto, los 8 CircularProgressIndicator y los 3 RefreshIndicator
        // que no llevan color propio salen del morado que Material 3 usa por
        // omisión, en una app azul y cian.
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: TecomnetTheme.azulMarca,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/recargar': (context) => const MenuScreen(),
        '/actualizarPlan': (context) => const UpdatePlanScreen(),
        '/refills': (context) => const RefillsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/changePassword': (context) => const ChangePasswordScreen(),
        '/recuperarPassword': (context) => const RecuperarPasswordScreen(),
      },
    );
  }
}
