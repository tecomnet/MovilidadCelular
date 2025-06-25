import 'package:flutter/material.dart';
import 'package:movilidad_celulares/screens/changePassword.dart';
import 'package:movilidad_celulares/screens/menu_screen.dart';
import 'package:movilidad_celulares/screens/moreData_screen.dart';
import 'package:movilidad_celulares/screens/profile_screen.dart';
import 'package:movilidad_celulares/screens/refills_screen.dart';
import 'package:movilidad_celulares/screens/register_screen.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/informationPayment_screen.dart';

void main() {
  runApp(const MyApp());
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
        '/register': (context) => const RegisterScreen(),
        '/menu': (context) => const MenuScreen(),
        '/moreData': (context) => const MoreDataScreen(),
        '/refills': (context) => const RefillsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/changePassword': (context) => const ChangePasswordScreen(),
      },
    );
  }
}
