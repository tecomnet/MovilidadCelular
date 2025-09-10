import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_strategy/url_strategy.dart';
import 'package:movilidad_celulares/call_native_code.dart';
import 'package:movilidad_celulares/utils/session_manager.dart';

import 'package:movilidad_celulares/screens/SimRedirectScreen.dart';
import 'package:movilidad_celulares/screens/change_password.dart';
import 'package:movilidad_celulares/screens/forgot_password.dart';
import 'package:movilidad_celulares/screens/more_data_screen.dart';
import 'package:movilidad_celulares/screens/profile_screen.dart';
import 'package:movilidad_celulares/screens/refills_screen.dart';
import 'package:movilidad_celulares/screens/success_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/information_payment_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (kIsWeb) {
      setPathUrlStrategy();
    } else {
      await CallNativeCode.callNativeInitialize();
    }

    final logged = await SessionManager.isLoggedIn();

    runApp(
      SessionWatcher(
        child: MyApp(isLogged: logged),
      ),
    );
  }, (error, stackTrace) {
    debugPrint("❌ Error en la app: $error");
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
    debugPrint("📱 AppLifecycleState cambió a: $state");

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      debugPrint("⏳ Usuario salió de la app, iniciando timer de 60 segundos...");
      _timer?.cancel();
      _timer = Timer(const Duration(minutes: 1), _handleTimeout);
    } else if (state == AppLifecycleState.resumed) {
      debugPrint("✅ Usuario volvió a la app, cancelando timer");
      _timer?.cancel();
    }
  }

  Future<void> _handleTimeout() async {
    debugPrint("! Tiempo de inactividad alcanzado. Cerrando sesión...");
    await SessionManager.logout();

    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({super.key, required this.isLogged});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, 
      debugShowCheckedModeBanner: false,
      title: 'Movilidad Celulares',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/payment': (context) => const InformationpaymentScreen(),
        '/moreData': (context) => const MoreDataScreen(),
        '/refills': (context) => const RefillsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/changePassword': (context) => const ChangePasswordScreen(),
        '/redirect': (context) => const SimRedirectScreen(),
        '/moreDataScreen': (context) => const MoreDataScreen(),
        '/recuperarPassword': (context) => const RecuperarPasswordScreen(),
        '/succes': (context) => const SuccessScreen(),
      },
    );
  }
}
