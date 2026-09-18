import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/services/payment_flow.dart';
import 'package:movilidad_celulares/utils/enums.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/widgets/line_selector.dart';
import 'package:movilidad_celulares/widgets/offer_card.dart';
import 'package:movilidad_celulares/widgets/tecomnet_widgets.dart';

/// Cambio de plan en tres pasos: línea → tipo de plan → oferta.
class UpdatePlanScreen extends StatefulWidget {
  const UpdatePlanScreen({super.key});

  @override
  State<UpdatePlanScreen> createState() => _UpdatePlanScreenState();
}

class _UpdatePlanScreenState extends State<UpdatePlanScreen> {
  bool _cargando = true;
  bool _cargandoOfertas = false;
  bool _procesandoPago = false;

  /// La carga falló, que no es lo mismo que no tener líneas. Inicio y Recargar
  /// ya distinguían los dos casos; aquí un corte de red seguía diciéndole al
  /// cliente que no encontramos líneas asociadas a su cuenta.
  bool _falloCarga = false;

  List<ClientLine> _lineas = [];
  ClientLine? _linea;
  TipoOferta? _tipo;
  List<Map<String, dynamic>> _ofertas = [];

  @override
  void initState() {
    super.initState();
    _cargarLineas();
  }

  Future<void> _cargarLineas() async {
    if (mounted) setState(() => _cargando = true);

    final perfil = await AuthService.obtenerPerfil();
    if (!mounted) return;

    final clienteId = perfil == null ? null : AuthService.clienteIdDe(perfil);
    final tablero = clienteId == null
        ? null
        : await AuthService.obtenerTablero(clienteId);
    if (!mounted) return;

    final lineas = (tablero ?? []).map(ClientLine.desde).toList();
    setState(() {
      _falloCarga = perfil == null || clienteId == null || tablero == null;
      _lineas = lineas;
      // Con una sola línea no hay nada que elegir en el primer paso.
      _linea = lineas.length == 1 ? lineas.first : null;
      _cargando = false;
    });
  }

  Future<void> _cargarOfertas(TipoOferta tipo) async {
    setState(() {
      _tipo = tipo;
      _cargandoOfertas = true;
      _ofertas = [];
    });

    final ofertas = await AuthService.obtenerOfertasPorTipo(
      tipoOfertaValor(tipo),
    );
    if (!mounted) return;

    setState(() {
      _ofertas = ofertas ?? [];
      _cargandoOfertas = false;
    });
  }

  bool get _puedeCambiarLinea => _lineas.length > 1;

  /// Cada tipo se cobra por un campo distinto del catálogo.
  double _precioDe(Map<String, dynamic> oferta, TipoOferta tipo) {
    final campo = switch (tipo) {
      TipoOferta.mensual => oferta['PrecioMensual'],
      TipoOferta.anual => oferta['PrecioAnual'],
      TipoOferta.recarga => oferta['PrecioRecurrente'],
    };
    return (campo as num?)?.toDouble() ?? 0;
  }

  String _periodoDe(TipoOferta tipo) => switch (tipo) {
    TipoOferta.mensual => 'MES',
    TipoOferta.anual => 'AÑO',
    TipoOferta.recarga => 'RECARGA',
  };

  String _tituloCatalogo(TipoOferta tipo) => switch (tipo) {
    TipoOferta.mensual => 'Planes mensuales',
    TipoOferta.anual => 'Planes anuales',
    TipoOferta.recarga => 'Recargas disponibles',
  };

  Future<void> _contratar(Map<String, dynamic> oferta) async {
    final linea = _linea;
    final tipo = _tipo;
    if (linea == null || tipo == null || _procesandoPago) return;

    final precio = _precioDe(oferta, tipo);
    if (precio <= 0) {
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
      operacion: TipoOperacion.Cambio,
    );
    if (!mounted) return;
    setState(() => _procesandoPago = false);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Actualizar plan',
      rutaActual: '/actualizarPlan',
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _cuerpo(),
    );
  }

  Widget _cuerpo() {
    if (_lineas.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: EmptyPanel(
          mensaje: _falloCarga
              ? 'No pudimos cargar tus líneas. Revisa tu conexión e intenta de nuevo.'
              : 'No encontramos líneas asociadas a tu cuenta',
        ),
      );
    }
    if (_linea == null) {
      return LineSelector(
        titulo: 'Elige la línea a actualizar',
        lineas: _lineas,
        onSeleccionar: (l) => setState(() {
          _linea = l;
          _tipo = null;
        }),
      );
    }
    if (_tipo == null) return _pasoTipo();
    return _pasoCatalogo();
  }

  // ---------- paso 2: tipo de plan ----------

  Widget _pasoTipo() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      children: [
        if (_puedeCambiarLinea) ...[
          StepBackButton(
            texto: 'Cambiar de línea',
            onTap: () => setState(() => _linea = null),
          ),
          const SizedBox(height: 20),
        ],
        StepHeader(
          titulo: '¿Qué tipo de plan quieres?',
          msisdn: _linea!.msisdn,
        ),
        const SizedBox(height: 20),
        PlanTypeCard(
          icono: Icons.event_available_outlined,
          titulo: 'Mensual',
          descripcion: 'Renovación automática cada mes.',
          onTap: () => _cargarOfertas(TipoOferta.mensual),
        ),
        PlanTypeCard(
          icono: Icons.account_balance_wallet_outlined,
          titulo: 'Prepago (Recargas)',
          descripcion: 'Sin mensualidad; pagas solo cuando recargas.',
          onTap: () => _cargarOfertas(TipoOferta.recarga),
        ),
        PlanTypeCard(
          icono: Icons.workspace_premium_outlined,
          titulo: 'Anual',
          descripcion: 'Paga por adelantado todo el año.',
          onTap: () => _cargarOfertas(TipoOferta.anual),
        ),
      ],
    );
  }

  // ---------- paso 3: catálogo ----------

  Widget _pasoCatalogo() {
    final tipo = _tipo!;

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: [
            StepBackButton(
              texto: 'Otro tipo de plan',
              onTap: () => setState(() {
                _tipo = null;
                _ofertas = [];
              }),
            ),
            const SizedBox(height: 20),
            StepHeader(titulo: _tituloCatalogo(tipo)),
            const SizedBox(height: 20),
            if (_cargandoOfertas)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_ofertas.isEmpty)
              const EmptyPanel(
                mensaje: 'No hay planes disponibles de este tipo',
                icono: Icons.inbox_outlined,
              )
            else
              ..._ofertas.map((o) => _tarjeta(o, tipo)),
          ],
        ),
      ],
    );
  }

  Widget _tarjeta(Map<String, dynamic> oferta, TipoOferta tipo) {
    return OfferCard(
      nombre: (oferta['Oferta'] ?? 'Plan').toString(),
      precio: _precioDe(oferta, tipo),
      datosGb: (oferta['DatosMB'] as num?) ?? 0,
      validezDias: (oferta['ValidezDias'] as num?)?.toInt() ?? 0,
      minutos: (oferta['Minutos'] as num?)?.toInt() ?? 0,
      sms: (oferta['Sms'] as num?)?.toInt() ?? 0,
      periodo: _periodoDe(tipo),
      textoBoton: 'Lo quiero',
      onSeleccionar: () => _contratar(oferta),
    );
  }
}
