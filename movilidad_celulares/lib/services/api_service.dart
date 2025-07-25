import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static String? _token;
  static String? _email;
  static String? _password;

  static Future<bool> obtenerToken(String usuario, String clave) async {
    final url = Uri.parse('https://tecomnet.net/TECOMNET_MOVILIDAD/WebApi/api/Account');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "UserName": "Mobile.TECOMNET.USER_Admin", 
          "Password": "VnhmJUD4ZW4564NHAyYD53FSH",
        }),
      );

      if (response.statusCode == 200) {
        _token = response.body.replaceAll('"', '');
        _email = usuario;
        _password = clave;
        print('✅ Token recibido: $_token');
        return true;
      } else {
        print('Error al obtener token: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión: $e');
      return false;
    }
  }

  static String? get token => _token;

  static String? get email => _email;
  static String? get password => _password;

  static Future<Map<String, dynamic>?> obtenerPerfil() async {
    if (_token == null || _email == null || _password == null) {
      print('Token o credenciales no disponibles');
      return null;
    }

    final url = Uri.parse('https://tecomnet.net/TECOMNET_MOVILIDAD/WebApi/api/Cliente/Login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'UserName': _email,
          'Password': _password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Perfil recibido: $data');
        return data;
      } else {
        print('Error al obtener perfil: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Excepción al obtener perfil: $e');
      return null;
    }
  }
  static Future<List<Map<String, dynamic>>?> obtenerTablero(int clienteId) async {
  if (_token == null) {
    print('⚠️ Token no disponible, no se puede obtener tablero');
    return null;
  }

  final url = Uri.parse(
    'https://tecomnet.net/TECOMNET_MOVILIDAD/WebApi/api/Cliente/Tablero/$clienteId',
  );

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final ofertas = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      print('✅ Tablero recibido: $ofertas');
      return ofertas;
    } else {
      print('❌ Error al obtener tebalero: ${response.statusCode}');
      print('Respuesta: ${response.body}');
      return null;
    }
  } catch (e) {
    print('🔥 Excepción al obtener tablero: $e');
    return null;
  }
}
  static Future<List<Map<String, dynamic>>?> obtenerOfertas() async {
  if (_token == null) {
    print('⚠️ Token no disponible, no se puede obtener ofertas');
    return null;
  }

  final url = Uri.parse(
    'https://tecomnet.net/TECOMNET_MOVILIDAD/WebApi/api/Ofertas/Activa',
  );

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final ofertas = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      print('✅ Ofertas recibidas: $ofertas');
      return ofertas;
    } else {
      print('❌ Error al obtener ofertas: ${response.statusCode}');
      print('Respuesta: ${response.body}');
      return null;
    }
  } catch (e) {
    print('🔥 Excepción al obtener ofertas: $e');
    return null;
  }
}


}
