import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static String? _token;
  static String? _email;
  static String? _password;

  static Future<bool> obtenerToken(String usuario, String clave) async {
    final url = Uri.parse('https://tecomnet.net/movilidad/WebApi/api/Account');

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

    final url = Uri.parse('https://tecomnet.net/movilidad/WebApi/api/Cliente/Login');
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
    'https://tecomnet.net/movilidad/WebApi/api/Cliente/Tablero/$clienteId',
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
    print('Excepción al obtener tablero: $e');
    return null;
  }
}
 static Future<List<Map<String, dynamic>>?> obtenerOfertasPorTipo(int tipo) async {
  if (_token == null) {
    print('⚠️ Token no disponible, no se puede obtener ofertas');
    return null;
  }

  final url = Uri.parse(
    'https://tecomnet.net/movilidad/WebApi/api/Ofertas/Activa/Tipo/$tipo',
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
      print('✅ Ofertas recibidas para tipo $tipo: $ofertas');
      return ofertas;
    } else {
      print('❌ Error al obtener ofertas: ${response.statusCode}');
      print('Respuesta: ${response.body}');
      return null;
    }
  } catch (e) {
    print(' Excepción al obtener ofertas: $e');
    return null;
  }
}

static Future<String?> generarOrderID({
  required String iccid,
  required String ofertaActualId,
  required String ofertaNuevaId,
  required String monto,
}) async {
  if (_token == null) {
    print('⚠️ Token no disponible, no se puede registrar la solicitud');
    return null;
  }

  final url = Uri.parse('https://tecomnet.net/movilidad/WebApi/api/RegistrarSolicitudDePago');

  final Map<String, dynamic> body = {
    "SolicitudID": "",
    "OrderID": "",
    "MetodoPagoID": "1",
    "OfertaIDActual": ofertaActualId,
    "OfertaIDNueva": ofertaNuevaId,
    "Monto": monto,
    "ICCID": iccid,
    "Estatus": "",
    "FechaCreacion": "",
    "EstatusDepositoID": "",
    "IdTransaction": "",
    "AuthNumber": "",
    "AuthCode": "",
    "Reason": "",
    "PagoDepositoID": "",
    "UltimaActualizacion": "",
    "NumeroReintentos": ""
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✅ OrderID generado: ${data['OrderID']}');
      return data['OrderID'];
    }
     else {
      print('❌ Error al generar OrderID: ${response.statusCode} -> ${response.body}');
      return null;
    }
  } catch (e) {
    print('💥 Excepción al generar OrderID: $e');
    return null;
  }
}

  static Future<String?> obtenerTokenRecargas(String email, String apiKey) async {
    final url = Uri.parse('https://lklapi.lklpay.com.mx/pef1d7972c8ro/auth/ecommerce/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
  "email": email,
  "apiKey": apiKey,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final token = decoded['response']['token'];
        print('✅ Token recibido: $token');
        return token;
      } else {
        print('❌ Error al obtener token: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('⚠️ Error de conexión al obtener token: $e');
      return null;
    }
  }

  static Future<String?> obtenerLinkDePago({
    required String token,
    required int amount,
    required String description,
    required String orderId,
  }) async {

    final url = Uri.parse('https://lklapi.lklpay.com.mx/f2c65bd1289pm/link/ecommerce');

    final body = {
      "amount": amount,
      "displayAmount": amount / 100,
      "displayCurrency": "MXN",
      "language": "es",
      "email": "h.martinez@tecomnet.mx",
      "commerceName": "TECOMNET",
      "supportEmail": "recargas@tecomnet.mx",
      "description": description,
      "response_url": "https://tecomnet.net/TECOMNET/webhook/ValidatePay/",
      "redirectUrl": "https://tecomnet.net/TECOMNET/WebClient/Views/Recharge/RechargeSure.aspx?opr=$orderId",
      "order_id": orderId,
      "origin": "ecommerce",
      "imageUrl": "https://www.tecomnet.mx/wp-content/uploads/2024/11/888-removebg-preview.png",
      "userData": {
        "firstName": "",
        "lastName": "",
        "phone": "",
        "email": "",
        "country": "",
        "state": "",
        "locality": "",
        "address": "",
        "zipCode": ""
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('📝 Respuesta de obtenerLinkDePago: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final paymentUrl = decoded['response']?['url'];

        if (paymentUrl != null) {
          print('✅ Link de pago: $paymentUrl');
          return paymentUrl;
        } else {
          print('❌ No se encontró el link de pago en la respuesta.');
          return null;
        }
      } else {
        print('❌ Error al obtener link de pago: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('⚠️ Error de conexión al obtener link de pago: $e');
      return null;
    }
  }

  static Future<String?> getPaymentStatus(String guid) async {
    final url = 'https://tecomnet.net/TECOMNET/Gateway/api/Altan/GetPaymentRequest/$guid';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['State'];
        return status?.toString().toLowerCase();
      } else {
        print('❌ Error al consultar estado de pago: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('⚠️ Excepción al consultar estatus: $e');
      return null;
    }
  }
}
