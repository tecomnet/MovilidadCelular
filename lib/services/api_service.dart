import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movilidad_celulares/services/idempotency.dart';

class AuthService {
  static String? _token;
  static String? _email;
  static String? _password;

  static Future<bool> obtenerToken(String usuario, String clave) async {
    final url = Uri.parse(
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io/api/Account',
    );

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "UserName": "Mobile.TECOMNET.USER_Admin",
              "Password":
                  "zE8D4nlrLpgpeG3qjiFwlFkUBNfun1LSwMqvZBLhnzXVyCy7VsFaVFDUiwpMHrlO",
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        _token = response.body.replaceAll('"', '');
        _email = usuario;
        _password = clave;
        if (kDebugMode) debugPrint('✅ Token recibido: $_token');
        return true;
      } else {
        if (kDebugMode) debugPrint(' ${response.statusCode}');
        if (kDebugMode) debugPrint('Respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error de conexión: $e');
      return false;
    }
  }

  static String? get token => _token;

  static String? get email => _email;
  static String? get password => _password;
  static int? _clienteId;
  static int? get clienteId => _clienteId;
  static set clienteId(int? value) {
    _clienteId = value;
  }

  // Se dispara cuando el servidor rechaza el token. Lo engancha main.dart para
  // cerrar la sesión y volver al login; aquí no se navega, porque este archivo
  // no sabe nada de pantallas.
  static void Function()? alCaducarSesion;

  // ¿El servidor dijo que el token ya no vale?
  //
  // El token dura 60 minutos y no se renueva. Antes un 401 se trataba como un
  // rechazo cualquiera: el usuario veía «no se pudo…» o una pantalla vacía y no
  // había forma de saber que lo que había caducado era su sesión.
  static bool _sesionCaduco(int statusCode) {
    if (statusCode != 401) return false;

    // Varias peticiones pueden ir en vuelo a la vez y recibir el 401 casi
    // juntas. Solo avisa la primera: cerrarSesion() deja el token en null, así
    // que las siguientes ya no encuentran sesión que cerrar.
    final habiaSesion = _token != null;
    if (kDebugMode) {
      debugPrint('🔒 Sesión caducada (401): se cierra y se vuelve al login');
    }
    cerrarSesion();
    if (habiaSesion) alCaducarSesion?.call();
    return true;
  }

  // Olvida todo lo de la sesión en curso. Se llama al salir: hasta ahora el
  // token, el correo y la contraseña se quedaban vivos en memoria después de
  // cerrar sesión, y la siguiente pantalla los seguía viendo.
  static void cerrarSesion() {
    _token = null;
    _email = null;
    _password = null;
    _clienteId = null;
  }

  // `validandoLogin` distingue los dos usos de este método, porque el API
  // responde 401 tanto si el token caducó como si la contraseña está mal, y por
  // el código no hay forma de saber cuál es. Al validar un login, un 401
  // significa credenciales incorrectas y no debe cerrar sesión; en cualquier
  // otra pantalla significa que el token murió.
  static Future<Map<String, dynamic>?> obtenerPerfil({
    bool validandoLogin = false,
  }) async {
    if (_token == null || _email == null || _password == null) {
      if (kDebugMode) debugPrint('Token o credenciales no disponibles');
      return null;
    }

    final url = Uri.parse(
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io/api/Cliente/Login',
    );
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'UserName': _email, 'Password': _password}),
          )
          .timeout(const Duration(seconds: 20));

      if (!validandoLogin && _sesionCaduco(response.statusCode)) return null;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (kDebugMode) debugPrint('Perfil recibido: $data');
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(' ${response.statusCode} - ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Excepción al obtener perfil: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> obtenerTablero(
    int clienteId,
  ) async {
    if (_token == null) {
      if (kDebugMode) {
        debugPrint('⚠️ Token no disponible, no se puede obtener tablero');
      }
      return null;
    }

    final url = Uri.parse(
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io/api/Cliente/Tablero/$clienteId',
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (_sesionCaduco(response.statusCode)) return null;

      if (response.statusCode == 200) {
        final ofertas = List<Map<String, dynamic>>.from(
          jsonDecode(response.body),
        );
        if (kDebugMode) debugPrint('✅ Tablero recibido: $ofertas');
        return ofertas;
      } else {
        if (kDebugMode) debugPrint(' ${response.statusCode}');
        if (kDebugMode) debugPrint('Respuesta: ${response.body}');
        return null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Excepción al obtener tablero: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> obtenerOfertasPorTipo(
    int tipo,
  ) async {
    if (_token == null) {
      if (kDebugMode) {
        debugPrint('⚠️ Token no disponible, no se puede obtener ofertas');
      }
      return null;
    }

    final url = Uri.parse(
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io/api/Ofertas/Activa/Tipo/$tipo',
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (_sesionCaduco(response.statusCode)) return null;

      if (response.statusCode == 200) {
        final ofertas = List<Map<String, dynamic>>.from(
          jsonDecode(response.body),
        );
        if (kDebugMode) {
          debugPrint('✅ Ofertas recibidas para tipo $tipo: $ofertas');
        }
        return ofertas;
      } else {
        if (kDebugMode) debugPrint(' ${response.statusCode}');
        if (kDebugMode) debugPrint('Respuesta: ${response.body}');
        return null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint(' Excepción al obtener ofertas: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> obtenerOfertaPorId(int ofertaId) async {
    if (_token == null) {
      if (kDebugMode) {
        debugPrint('⚠️ Token no disponible, no se puede obtener oferta');
      }
      return null;
    }

    final url = Uri.parse(
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io/api/Ofertas/$ofertaId',
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (_sesionCaduco(response.statusCode)) return null;

      if (response.statusCode == 200) {
        final oferta = jsonDecode(response.body) as Map<String, dynamic>;
        if (kDebugMode) {
          debugPrint('✅ Oferta recibida con ID $ofertaId: $oferta');
        }
        return oferta;
      } else {
        if (kDebugMode) debugPrint('${response.statusCode}');
        if (kDebugMode) debugPrint('Respuesta: ${response.body}');
        return null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Excepción al obtener oferta: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> obtenerMetodosPago() async {
    if (_token == null) {
      if (kDebugMode) {
        debugPrint(
          '⚠️ Token no disponible, no se pueden obtener métodos de pago',
        );
      }
      return null;
    }

    final url = Uri.parse(
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io/api/MetodoPago',
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (_sesionCaduco(response.statusCode)) return null;

      if (response.statusCode == 200) {
        final metodos = List<Map<String, dynamic>>.from(
          jsonDecode(response.body),
        );
        if (kDebugMode) debugPrint('✅ Métodos de pago recibidos: $metodos');
        return metodos;
      } else {
        if (kDebugMode) debugPrint(' ${response.statusCode}');
        if (kDebugMode) debugPrint('Respuesta: ${response.body}');
        return null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Excepción al obtener métodos de pago: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> registrarSolicitudDePago({
    required String iccid,
    required String msisdn,
    required int ofertaActualId,
    required int ofertaNuevaId,
    required double monto,
    required int tipoOperacion,
    required int canalVenta,
    int metodoPagoId = 1,
    int distribuidorId = 1,
  }) async {
    if (_token == null) {
      if (kDebugMode) {
        debugPrint(
          '⚠️ Token no disponible, no se puede registrar la solicitud',
        );
      }
      return null;
    }

    final idempotencyKey = await Idempotency.obtener(
      iccid: iccid,
      ofertaNuevaId: ofertaNuevaId.toString(),
      tipoOperacion: tipoOperacion,
    );

    final url = Uri.parse(
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io/api/RegistrarSolicitudDePago',
    );

    final Map<String, dynamic> body = {
      "ICCID": iccid,
      "MSISDN": msisdn,
      "MetodoPagoID": metodoPagoId,
      "OfertaIDActual": ofertaActualId,
      "OfertaIDNueva": ofertaNuevaId,
      "Monto": monto,
      "CanalDeVenta": canalVenta,
      "TipoOperacion": tipoOperacion,
      "DistribuidorID": distribuidorId,
      "IdempotencyKey": idempotencyKey,
    };

    for (var intento = 1; intento <= 3; intento++) {
      try {
        final response = await http
            .post(
              url,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $_token',
              },
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 20));

        if (_sesionCaduco(response.statusCode)) return null;

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          if (kDebugMode) debugPrint('✅ OrderID generado: ${data['OrderID']}');
          return data;
        }

        if (response.statusCode >= 400 && response.statusCode < 500) {
          if (kDebugMode) {
            debugPrint(
              '❌ Solicitud rechazada: ${response.statusCode} -> ${response.body}',
            );
          }
          return null;
        }

        if (kDebugMode) {
          debugPrint(
            '⚠️ Error del servidor (${response.statusCode}), intento $intento',
          );
        }
      } on TimeoutException {
        if (kDebugMode) debugPrint('⏱️ Timeout en el intento $intento de 3');
      } catch (e) {
        if (kDebugMode) {
          debugPrint('💥 Error de red en el intento $intento: $e');
        }
      }

      if (intento < 3) {
        await Future.delayed(Duration(seconds: intento * 2));
      }
    }

    if (kDebugMode) {
      debugPrint('❌ No se pudo registrar la solicitud tras 3 intentos');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> obtenerSolicitudDePago(
    String orderId,
  ) async {
    if (_token == null) {
      if (kDebugMode) {
        debugPrint(
          '⚠️ Token no disponible, no se puede consultar la solicitud',
        );
      }
      return null;
    }

    final url = Uri.parse(
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io/api/ObtenerSolicitudDePago/${Uri.encodeComponent(orderId)}',
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (_sesionCaduco(response.statusCode)) return null;

      if (response.statusCode == 200) {
        final cuerpo = response.body.trim();
        if (cuerpo.isEmpty) {
          if (kDebugMode) {
            debugPrint('No existe solicitud con OrderID $orderId');
          }
          return null;
        }
        final data = jsonDecode(cuerpo) as Map<String, dynamic>;
        // La respuesta viene envuelta: {"objSolicitudDePago": { ... }}
        final interior = data['objSolicitudDePago'];
        if (interior is Map<String, dynamic>) return interior;
        return data;
      } else {
        if (kDebugMode) debugPrint(' ${response.statusCode}');
        if (kDebugMode) debugPrint('Respuesta: ${response.body}');
        return null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Excepción al consultar la solicitud: $e');
      return null;
    }
  }

  static Future<void> liberarIntento({
    required String iccid,
    required int ofertaNuevaId,
    required int tipoOperacion,
  }) {
    return Idempotency.liberar(
      iccid: iccid,
      ofertaNuevaId: ofertaNuevaId.toString(),
      tipoOperacion: tipoOperacion,
    );
  }

  static Future<bool> cambiarPassword({
    required String passwordActual,
    required String passwordNueva,
  }) async {
    if (_token == null) {
      if (kDebugMode) {
        debugPrint('Token no disponible, no se puede cambiar la contraseña');
      }
      return false;
    }

    final url = Uri.parse(
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io/api/Cliente/CambiaPassword',
    );

    final body = {
      "UserName": AuthService.email,
      "Password": passwordActual,
      "NewPassword": passwordNueva,
    };

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        if (kDebugMode) debugPrint('Se cambió la contraseña con éxito');
        return true;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Error al cambiar contraseña: ${response.statusCode} - ${response.body}',
          );
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Excepción al cambiar contraseña: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>?> obtenerRecargas(
    int clienteId,
  ) async {
    if (_token == null) {
      if (kDebugMode) {
        debugPrint('⚠️ Token no disponible, no se puede obtener tablero');
      }
      return null;
    }

    final url = Uri.parse(
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io/api/Recargas/Cliente/$clienteId',
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (_sesionCaduco(response.statusCode)) return null;

      if (response.statusCode == 200) {
        final recargas = List<Map<String, dynamic>>.from(
          jsonDecode(response.body),
        );
        if (kDebugMode) debugPrint('✅ Recargas recibidas: $recargas');
        return recargas;
      } else {
        if (kDebugMode) debugPrint(' ${response.statusCode}');
        if (kDebugMode) debugPrint('Respuesta: ${response.body}');
        return null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Excepción al obtener recargas: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> recuperarContrasena(String email) async {
    if (_token == null) {
      if (kDebugMode) debugPrint('Token no disponible');
      return null;
    }

    final url = Uri.parse(
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io/api/Cliente/SolicitudCambioPassword',
    );
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (kDebugMode) debugPrint('Respuesta: $data');
        return data;
      } else {
        if (kDebugMode) {
          debugPrint('Error: ${response.statusCode} - ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Excepción: $e');
      return null;
    }
  }
}
