import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movilidad_celulares/config/ambiente.dart';
import 'package:movilidad_celulares/services/idempotency.dart';
import 'package:movilidad_celulares/services/tarjeta.dart';

class AuthService {
  static String get _base => Ambiente.api;

  static String? _token;
  static String? _email;
  static String? _password;

  static Future<bool> obtenerToken(String usuario, String clave) async {
    final url = Uri.parse('$_base/api/Account');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            // La cuenta de servicio cambia entre pruebas y producción, así que
            // sale de Ambiente junto con la URL: un solo lugar que tocar.
            body: jsonEncode({
              "UserName": Ambiente.usuarioServicio,
              "Password": Ambiente.claveServicio,
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

  static void Function()? alCaducarSesion;

  static bool _sesionCaduco(int statusCode) {
    if (statusCode != 401) return false;

    final habiaSesion = _token != null;
    if (kDebugMode) {
      debugPrint('🔒 Sesión caducada (401): se cierra y se vuelve al login');
    }
    cerrarSesion();
    if (habiaSesion) alCaducarSesion?.call();
    return true;
  }

  static void cerrarSesion() {
    _token = null;
    _email = null;
    _password = null;
    _clienteId = null;
  }

  static Future<Map<String, dynamic>?> obtenerPerfil({
    bool validandoLogin = false,
  }) async {
    if (_token == null || _email == null || _password == null) {
      if (kDebugMode) debugPrint('Token o credenciales no disponibles');
      return null;
    }

    final url = Uri.parse('$_base/api/Cliente/Login');
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

  static int? clienteIdDe(Map<String, dynamic> perfil) {
    final valor = perfil['ClienteId'];
    if (valor is num) return valor.toInt();
    return int.tryParse('$valor');
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

    final url = Uri.parse('$_base/api/Cliente/Tablero/$clienteId');

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

    final url = Uri.parse('$_base/api/Ofertas/Activa/Tipo/$tipo');

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

    final url = Uri.parse('$_base/api/Ofertas/$ofertaId');

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

    final url = Uri.parse('$_base/api/MetodoPago');

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

    final url = Uri.parse('$_base/api/RegistrarSolicitudDePago');

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
      '$_base/api/ObtenerSolicitudDePago/${Uri.encodeComponent(orderId)}',
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

    final url = Uri.parse('$_base/api/Cliente/CambiaPassword');

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

    final url = Uri.parse('$_base/api/Recargas/Cliente/$clienteId');

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

    final url = Uri.parse('$_base/api/Cliente/SolicitudCambioPassword');
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

  static Future<int?> clienteIdActual() async {
    if (_clienteId != null) return _clienteId;
    final perfil = await obtenerPerfil();
    if (perfil == null) return null;
    return _clienteId = clienteIdDe(perfil);
  }

  static String? _mensajeDe(String cuerpo) {
    try {
      final json = jsonDecode(cuerpo);
      if (json is String) return json.trim().isEmpty ? null : json.trim();
      if (json is! Map) return null;
      for (final nombre in [
        'mensaje',
        'detalle',
        'detail',
        'message',
        'title',
      ]) {
        final valor = campo(json, nombre)?.toString().trim() ?? '';
        if (valor.isNotEmpty) return valor;
      }
    } catch (_) {}
    return null;
  }

  static Future<ResultadoTokenizar?> tokenizarTarjeta({
    required int clienteId,
    required String numero,
    required String titular,
    required String cvv,
    required int mesVencimiento,
    required int anioVencimiento,
    required String correo,
    required String telefono,
  }) async {
    if (_token == null) return null;

    final url = Uri.parse('$_base/api/cobros/tokenizar');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'ClienteID': clienteId,
              'CardNumber': numero,
              'Cardholder': titular,
              'Cvv': cvv,
              'ExpMonth': mesVencimiento,
              'ExpYear': anioVencimiento,
              'Email': correo,
              'PhoneNumber': telefono,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (_sesionCaduco(response.statusCode)) return null;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map json = const {};
        try {
          final cuerpo = jsonDecode(response.body);
          if (cuerpo is Map) json = cuerpo;
        } catch (_) {}
        return ResultadoTokenizar(
          ok: true,
          cardId: campo(json, 'cardId')?.toString(),
          yaEstaba: campo(json, 'yaEstaba') == true,
        );
      }

      final detalle = _mensajeDe(response.body);
      return ResultadoTokenizar(
        ok: false,
        mensaje: switch (response.statusCode) {
          400 =>
            detalle ??
                'Faltan datos de la tarjeta. Revísalos e intenta de nuevo.',
          502 =>
            detalle == null
                ? 'El banco no aceptó la tarjeta. Revisa los datos o usa otra.'
                : 'El banco no aceptó la tarjeta: $detalle',
          _ => 'No se pudo agregar la tarjeta. Intenta de nuevo más tarde.',
        },
      );
    } catch (_) {
      return null;
    }
  }

  static Future<List<Tarjeta>?> obtenerTarjetas(int clienteId) async {
    if (_token == null) return null;

    final url = Uri.parse('$_base/api/cobros/tarjetas/$clienteId');

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

      if (response.statusCode != 200) {
        if (kDebugMode) debugPrint('Tarjetas: ${response.statusCode}');
        return null;
      }

      final cuerpo = response.body.trim();
      if (cuerpo.isEmpty) return const [];
      final json = jsonDecode(cuerpo);
      if (json is! List) return null;

      final tarjetas = json
          .whereType<Map>()
          .map(Tarjeta.desde)
          .whereType<Tarjeta>()
          .toList();
      if (kDebugMode) debugPrint('✅ Tarjetas recibidas: ${tarjetas.length}');
      return tarjetas;
    } catch (e) {
      if (kDebugMode) debugPrint('Excepción al obtener tarjetas: $e');
      return null;
    }
  }

  static Future<ResultadoQuitarTarjeta?> quitarTarjeta({
    required int clienteId,
    required int clienteTarjetaId,
    bool forzar = false,
  }) async {
    if (_token == null) return null;

    final url = Uri.parse(
      '$_base/api/cobros/tarjetas/$clienteId/$clienteTarjetaId?forzar=$forzar',
    );

    try {
      final response = await http
          .delete(
            url,
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (_sesionCaduco(response.statusCode)) return null;

      Map json = const {};
      try {
        final cuerpo = jsonDecode(response.body);
        if (cuerpo is Map) json = cuerpo;
      } catch (_) {}
      final lineas = lineasDe(campo(json, 'lineasQueCobra'));
      final mensaje = _mensajeDe(response.body);

      if (kDebugMode) debugPrint('Quitar tarjeta: ${response.statusCode}');

      return switch (response.statusCode) {
        200 => ResultadoQuitarTarjeta(
          EstadoQuitarTarjeta.quitada,
          lineasQueCobra: lineas,
        ),
        409 => ResultadoQuitarTarjeta(
          EstadoQuitarTarjeta.requiereConfirmacion,
          lineasQueCobra: lineas,
          mensaje: mensaje,
        ),
        404 => const ResultadoQuitarTarjeta(EstadoQuitarTarjeta.noEncontrada),
        502 => ResultadoQuitarTarjeta(
          EstadoQuitarTarjeta.pasarelaNoConfirmo,
          mensaje: mensaje,
        ),
        _ => ResultadoQuitarTarjeta(
          EstadoQuitarTarjeta.error,
          mensaje: mensaje,
        ),
      };
    } catch (e) {
      if (kDebugMode) debugPrint('Excepción al quitar tarjeta: $e');
      return null;
    }
  }
}
