import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/services/payment_flow.dart';
import 'package:movilidad_celulares/utils/enums.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/widgets/line_selector.dart';
import 'package:movilidad_celulares/widgets/offer_card.dart';
import 'package:movilidad_celulares/widgets/tecomnet_widgets.dart';

/// Flujo de recarga en dos pasos: elegir línea y elegir paquete.
///
/// Con una sola línea se salta el primer paso, porque no hay nada que elegir.
class MenuScreen extends StatefulWidget {
  /// Si viene informada, se entra directo al catálogo de esa línea.
  final String? msisdnInicial;

  const MenuScreen({super.key, this.msisdnInicial});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _cargando = true;
  bool _procesandoPago = false;

  /// La carga falló, que no es lo mismo que no tener líneas.
  bool _falloCarga = false;

  List<ClientLine> _lineas = [];
  List<Map<String, dynamic>> _ofertas = [];
  ClientLine? _seleccionada;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (mounted) setState(() => _cargando = true);

    final perfil = await AuthService.obtenerPerfil();
    if (!mounted) return;

    final clienteId = perfil == null ? null : AuthService.clienteIdDe(perfil);
    final tablero = clienteId == null
        ? null
        : await AuthService.obtenerTablero(clienteId);
    if (!mounted) return;

    final lineas = (tablero ?? []).map(ClientLine.desde).toList();
    final fallo = perfil == null || tablero == null;

    // Las recargas son ofertas de tipo 1.
    final ofertas = await AuthService.obtenerOfertasPorTipo(
      tipoOfertaValor(TipoOferta.recarga),
    );
    if (!mounted) return;

    setState(() {
      _falloCarga = fallo;
      _lineas = lineas;
      _ofertas = ofertas ?? [];
      // Con una sola línea no tiene sentido preguntar cuál.
      _seleccionada = _resolverSeleccion(lineas);
      _cargando = false;
    });
  }

  ClientLine? _resolverSeleccion(List<ClientLine> lineas) {
    if (lineas.isEmpty) return null;
    if (widget.msisdnInicial != null) {
      for (final l in lineas) {
        if (l.msisdn == widget.msisdnInicial) return l;
      }
    }
    return lineas.length == 1 ? lineas.first : null;
  }

  /// Solo se puede cambiar de línea si de verdad hay más de una.
  bool get _puedeCambiarLinea => _lineas.length > 1;

  Future<void> _recargar(Map<String, dynamic> oferta) async {
    final linea = _seleccionada;
    if (linea == null || _procesandoPago) return;

    final precio = (oferta['PrecioRecurrente'] as num?)?.toDouble();
    if (precio == null) {
      showNotice(context, 'Esta oferta no tiene precio configurado');
      return;
    }

    // La rueda la pone PaymentFlow con su propio diálogo; esta bandera solo
    // evita que un doble toque lance dos cobros antes de que aparezca.
    setState(() => _procesandoPago = true);
    await PaymentFlow.iniciar(
      context,
      iccid: linea.iccid,
      msisdn: linea.msisdn,
      ofertaActualId: int.tryParse(linea.ofertaId) ?? 0,
      ofertaNuevaId: (oferta['OfertaID'] as num?)?.toInt() ?? 0,
      monto: precio,
      operacion: TipoOperacion.Recarga,
    );
    if (!mounted) return;
    setState(() => _procesandoPago = false);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Recargar',
      rutaActual: '/recargar',
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _lineas.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: EmptyPanel(
                mensaje: _falloCarga
                    ? 'No pudimos cargar tus líneas. Revisa tu conexión '
                          'o vuelve a iniciar sesión.'
                    : 'No encontramos líneas asociadas a tu cuenta',
                icono: _falloCarga
                    ? Icons.cloud_off_rounded
                    : Icons.sim_card_outlined,
              ),
            )
          : _seleccionada == null
          ? LineSelector(
              titulo: 'Elige la línea a recargar',
              lineas: _lineas,
              onSeleccionar: (l) => setState(() => _seleccionada = l),
            )
          : _pasoElegirRecarga(),
    );
  }

  Widget _pasoElegirRecarga() {
    final linea = _seleccionada!;

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: [
            if (_puedeCambiarLinea) ...[
              StepBackButton(
                texto: 'Cambiar de línea',
                onTap: () => setState(() => _seleccionada = null),
              ),
              const SizedBox(height: 20),
            ],
            StepHeader(titulo: 'Elige tu recarga', msisdn: linea.msisdn),
            const SizedBox(height: 20),
            if (_ofertas.isEmpty)
              const EmptyPanel(
                mensaje: 'No hay recargas disponibles en este momento',
                icono: Icons.inbox_outlined,
              )
            else
              ..._ofertas.map(_tarjetaOferta),
          ],
        ),
      ],
    );
  }

  Widget _tarjetaOferta(Map<String, dynamic> oferta) {
    return OfferCard(
      nombre: (oferta['Oferta'] ?? 'Plan').toString(),
      precio: (oferta['PrecioRecurrente'] as num?)?.toDouble() ?? 0,
      datosGb: (oferta['DatosMB'] as num?) ?? 0,
      validezDias: (oferta['ValidezDias'] as num?)?.toInt() ?? 0,
      minutos: (oferta['Minutos'] as num?)?.toInt() ?? 0,
      sms: (oferta['Sms'] as num?)?.toInt() ?? 0,
      onSeleccionar: () => _recargar(oferta),
    );
  }
}
