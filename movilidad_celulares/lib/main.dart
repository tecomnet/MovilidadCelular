import 'package:flutter/material.dart';
import 'package:movilidad_celulares/screens/SimRedirectScreen.dart';
import 'package:movilidad_celulares/screens/change_password.dart';
import 'package:movilidad_celulares/screens/menu_screen.dart';
import 'package:movilidad_celulares/screens/more_data_screen.dart';
import 'package:movilidad_celulares/screens/profile_screen.dart';
import 'package:movilidad_celulares/screens/refills_screen.dart';
import 'package:movilidad_celulares/screens/update_plan_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/information_payment_screen.dart';
import 'package:movilidad_celulares/call_native_code.dart';
import 'dart:async';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await CallNativeCode.callNativeInitialize();

    runApp(const MyApp());
  }, (error, stackTrace) {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movilidad Celulares',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/payment': (context) => const InformationpaymentScreen(),
        '/menu': (context) => const MenuScreen(),
        '/moreData': (context) => const MoreDataScreen(),
        '/refills': (context) => const RefillsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/changePassword': (context) => const ChangePasswordScreen(),
        '/updatePlanScreen': (context) => const UpdatePlanScreen(),
        '/redirect': (context) => const SimRedirectScreen(),
        '/moreDataScreen': (context) => const MoreDataScreen(),
      },
    );
  }
}
