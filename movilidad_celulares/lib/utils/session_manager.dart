import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyLoggedIn = "isLoggedIn";
  static const _keyUser = "savedUser";
  static const _keyLoginTime = "loginTime"; 

  static const sessionDuration = 1; 

  static Future<void> login(String username, {bool remember = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setInt(_keyLoginTime, DateTime.now().millisecondsSinceEpoch); 
    if (remember) {
      await prefs.setString(_keyUser, username);
    } else {
      await prefs.remove(_keyUser);
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyLoginTime);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_keyLoggedIn) ?? false;

    if (!loggedIn) return false;

    final loginTime = prefs.getInt(_keyLoginTime) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final diffMinutes = (now - loginTime) ~/ 60000;

    if (diffMinutes > sessionDuration) {
      await logout(); 
      return false;
    }
    return true;
  }

  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUser);
  }

  static Future<void> refreshSession() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_keyLoginTime, DateTime.now().millisecondsSinceEpoch);
}

}
