import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyLoggedIn = "isLoggedIn";
  static const _keyUser = "savedUser";

  // Guardar sesión
  static Future<void> login(String username, {bool remember = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    if (remember) {
      await prefs.setString(_keyUser, username);
    } else {
      await prefs.remove(_keyUser);
    }
  }

  // Cerrar sesión
  static Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  // Borra solo la sesión, pero conserva el usuario guardado si existía
  await prefs.remove(_keyLoggedIn);
}

  // Validar si hay sesión activa
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  // Obtener usuario guardado
  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUser);
  }
}
