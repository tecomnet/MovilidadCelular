import 'package:flutter/material.dart';
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
import 'package:movilidad_celulares/call_native_code.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_strategy/url_strategy.dart';
import 'package:movilidad_celulares/utils/session_manager.dart';
void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();


    if (kIsWeb) {
    setPathUrlStrategy();
  } else {
    await CallNativeCode.callNativeInitialize();
  }
 final logged = await SessionManager.isLoggedIn();
    runApp(MyApp(isLogged: logged));
  }, (error, stackTrace) {
  });
}

class MyApp extends StatefulWidget {
  final bool isLogged;
  const MyApp({super.key, required this.isLogged});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _sessionTimer;

  @override
  void initState() {
    super.initState();
    _sessionTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkSession();
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }

  void _onUserInteraction([_]) {
    SessionManager.refreshSession();
  }

  Future<void> _checkSession() async {
    final stillLogged = await SessionManager.isLoggedIn();
    if (!stillLogged && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onUserInteraction,
      onPanDown: _onUserInteraction,
      onScaleStart: _onUserInteraction,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movilidad Celulares',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: widget.isLogged ? '/home' : '/login',
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
      ),
    );
  }
}

