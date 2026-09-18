// Tarjetas guardadas del cliente: el modelo del listado y los resultados de
// agregar y quitar. Las llamadas HTTP viven en AuthService, junto a las demás.

/// Busca [nombre] en [json] sin distinguir mayúsculas.
///
/// El API no es uniforme: tokenizar responde `cardId` y el listado documenta
/// `CardId`, y el borrado responde `lineasQueCobra` mientras el listado dice
/// `LineasQueCobra`. Leerlos así evita que un cambio de convención en el
/// servidor deje campos vacíos sin que nadie lo note.
dynamic campo(Map json, String nombre) {
  if (json.containsKey(nombre)) return json[nombre];
  final buscado = nombre.toLowerCase();
  for (final entrada in json.entries) {
    if (entrada.key.toString().toLowerCase() == buscado) return entrada.value;
  }
  return null;
}

int? _entero(dynamic v) => v is num ? v.toInt() : int.tryParse('${v ?? ''}');

String? _texto(dynamic v) {
  final t = v?.toString().trim() ?? '';
  return t.isEmpty ? null : t;
}

List<String> lineasDe(dynamic v) => v is List
    ? v.map((e) => '$e'.trim()).where((e) => e.isNotEmpty).toList()
    : const [];

/// Una tarjeta del listado `GET /api/cobros/tarjetas/{clienteId}`.
class Tarjeta {
  /// Identificador del catálogo. Es el que se usa para quitarla, **no** el
  /// [cardId]: confundirlos hace que el borrado responda 404.
  final int clienteTarjetaId;
  final String cardId;
  final String? marca;
  final String? ultimos4;
  final int? mes;
  final int? anio;
  final bool vencida;
  final DateTime? fechaAlta;

  /// Líneas cuyo plan mensual se cobra con esta tarjeta.
  final List<String> lineasQueCobra;

  const Tarjeta({
    required this.clienteTarjetaId,
    required this.cardId,
    this.marca,
    this.ultimos4,
    this.mes,
    this.anio,
    this.vencida = false,
    this.fechaAlta,
    this.lineasQueCobra = const [],
  });

  /// Devuelve null si falta el identificador del catálogo: sin él no se podría
  /// quitar, y mostrar una tarjeta que no se puede quitar solo confunde.
  static Tarjeta? desde(Map json) {
    final id = _entero(campo(json, 'ClienteTarjetaID'));
    if (id == null) return null;
    return Tarjeta(
      clienteTarjetaId: id,
      cardId: _texto(campo(json, 'CardId')) ?? '',
      marca: _texto(campo(json, 'Marca')),
      ultimos4: _texto(campo(json, 'Ultimos4')),
      mes: _entero(campo(json, 'ExpMonth')),
      anio: _entero(campo(json, 'ExpYear')),
      vencida: campo(json, 'Vencida') == true,
      fechaAlta: DateTime.tryParse('${campo(json, 'FechaAlta') ?? ''}'),
      lineasQueCobra: lineasDe(campo(json, 'LineasQueCobra')),
    );
  }

  /// Las registradas antes de que existiera el catálogo solo heredaron el
  /// token: no traen marca ni últimos 4 dígitos.
  bool get esHeredada => ultimos4 == null;

  /// «•••• •••• •••• 2701», como en la tarjeta dibujada de la web.
  String? get numeroEnmascarado =>
      esHeredada ? null : '•••• •••• •••• $ultimos4';

  /// «Visa •••• 2701», o «Tarjeta registrada» si es de las heredadas: el mismo
  /// texto que usa la app web para esas.
  String get nombre {
    if (esHeredada) return 'Tarjeta registrada';
    final m = marca;
    final nombreMarca = m == null
        ? 'Tarjeta'
        : '${m[0].toUpperCase()}${m.substring(1).toLowerCase()}';
    return '$nombreMarca •••• $ultimos4';
  }

  /// «12/28», o null si el servidor no mandó el vencimiento.
  String? get vencimiento {
    final m = mes, a = anio;
    if (m == null || a == null) return null;
    return '${m.toString().padLeft(2, '0')}/${(a % 100).toString().padLeft(2, '0')}';
  }
}

/// Resultado de `POST /api/cobros/tokenizar`.
class ResultadoTokenizar {
  final bool ok;

  /// El identificador que devolvió el servidor. Si la tarjeta ya estaba
  /// guardada es el de la original, no uno nuevo.
  final String? cardId;

  /// La misma tarjeta (marca, últimos 4 y vencimiento) ya estaba en la cuenta:
  /// el servidor conservó la original y descartó la nueva.
  final bool yaEstaba;

  /// Qué decirle al cliente cuando no se pudo.
  final String? mensaje;

  const ResultadoTokenizar({
    required this.ok,
    this.cardId,
    this.yaEstaba = false,
    this.mensaje,
  });
}

enum EstadoQuitarTarjeta {
  quitada,

  /// 409: la tarjeta cobra el plan mensual de alguna línea. No se borró nada;
  /// hay que confirmarlo con el cliente y repetir con forzar.
  requiereConfirmacion,

  /// 404: no existe o es de otro cliente (el servidor no los distingue).
  noEncontrada,

  /// 502: la pasarela no confirmó el borrado y la tarjeta sigue activa.
  pasarelaNoConfirmo,

  /// Cualquier otra respuesta (400, 500…).
  error,
}

/// Resultado de `DELETE /api/cobros/tarjetas/{clienteId}/{clienteTarjetaId}`.
class ResultadoQuitarTarjeta {
  final EstadoQuitarTarjeta estado;
  final List<String> lineasQueCobra;
  final String? mensaje;

  const ResultadoQuitarTarjeta(
    this.estado, {
    this.lineasQueCobra = const [],
    this.mensaje,
  });
}
