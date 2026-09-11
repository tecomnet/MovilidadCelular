import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:movilidad_celulares/call_native_code.dart';
import 'package:movilidad_celulares/screens/menu_screen.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/services/payment_flow.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';
import 'package:movilidad_celulares/utils/enums.dart';
import 'package:movilidad_celulares/utils/session_manager.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/widgets/line_card.dart';

/// Una línea del tablero, ya resuelta con el detalle de su oferta.
class _Linea {
  final Map<String, dynamic> tablero;
  final Map<String, dynamic>? detalle;

  const _Linea(this.tablero, this.detalle);

  String get plan {
    final nombre = detalle?['Oferta'] ?? tablero['Oferta'] ?? 'Plan';
    return nombre.toString().toUpperCase();
  }

  String get msisdn => tablero['MSISDN']?.toString() ?? '';
  String get iccid => tablero['ICCID']?.toString() ?? '';
  String get ofertaId => tablero['OfertaID']?.toString() ?? '';

  /// El tipo se lee primero del tablero y solo si falta se busca en el
  /// detalle: así la insignia sigue siendo correcta aunque la llamada al
  /// detalle de la oferta falle.
  TipoOferta? get tipo =>
      tipoOfertaDesde(tablero['Tipo']) ?? tipoOfertaDesde(detalle?['Tipo']);

  /// Tipo 1. Si el tipo viniera desconocido se trata como recarga: es el caso
  /// seguro, porque no ofrece renovar a un precio que no sabemos calcular.
  bool get esRecarga => tipo != TipoOferta.mensual && tipo != TipoOferta.anual;

  /// Cada tipo cobra por un campo distinto, igual que en update_plan_screen.
  double get precio {
    final campo = switch (tipo) {
      TipoOferta.mensual => detalle?['PrecioMensual'],
      TipoOferta.anual => detalle?['PrecioAnual'],
      _ => detalle?['PrecioRecurrente'],
    };
    return (campo as num?)?.toDouble() ?? 0.0;
  }

  double get mbUsados => (tablero['MBUsados'] as num?)?.toDouble() ?? 0.0;
  double get mbDisponibles =>
      (tablero['MBDisponibles'] as num?)?.toDouble() ?? 0.0;

  String get vigencia {
    final fecha = tablero['FechaVencimiento']?.toString();
    if (fecha == null || fecha.isEmpty) return '';
    final soloFecha = fecha.split('T').first;
    final partes = soloFecha.split('-');
    // De 2027-08-25 a 25/08/2027, como en el portal web.
    if (partes.length == 3) return '${partes[2]}/${partes[1]}/${partes[0]}';
    return soloFecha;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<_Linea> _lineas = [];
  bool _cargando = true;
  String _nombre = '';

  /// La carga falló (red caída o sesión caducada), que no es lo mismo que no
  /// tener líneas. Antes los dos casos mostraban «no encontramos líneas» y el
  /// usuario creía haberlas perdido.
  bool _falloCarga = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (mounted) setState(() => _cargando = true);

    final perfil = await AuthService.obtenerPerfil();
    if (!mounted) return;

    if (perfil == null) {
      setState(() {
        _cargando = false;
        _lineas = [];
        _falloCarga = true;
      });
      return;
    }

    final nombre = '${perfil['Nombre'] ?? ''}'.trim();
    final clienteId = perfil['ClienteId'];
    final tablero = await AuthService.obtenerTablero(clienteId);
    if (!mounted) return;

    if (tablero == null) {
      setState(() {
        _nombre = nombre;
        _lineas = [];
        _cargando = false;
        _falloCarga = true;
      });
      return;
    }

    if (tablero.isEmpty) {
      setState(() {
        _nombre = nombre;
        _lineas = [];
        _cargando = false;
        _falloCarga = false;
      });
      return;
    }

    // El detalle de cada oferta se resuelve UNA vez aquí. Antes vivía en un
    // FutureBuilder dentro de build(), así que se volvía a pedir por red en
    // cada repintado de la pantalla.
    final lineas = <_Linea>[];
    for (final fila in tablero) {
      final ofertaId = fila['OfertaID'];
      final detalle = ofertaId is int
          ? await AuthService.obtenerOfertaPorId(ofertaId)
          : null;
      lineas.add(_Linea(fila, detalle));
    }
    if (!mounted) return;

    // Registro del dispositivo en el SDK, ya con el MSISDN real.
    //
    // Se monitorea la PRIMERA línea del tablero, a propósito. Antes había un
    // firstWhere que buscaba `Estatus == '1'` y caía en `lineas.first` si no
    // encontraba ninguna: como el API devuelve «Active», esa condición no se
    // cumplía nunca y el resultado era siempre el mismo. Se quita porque el
    // código daba a entender otra regla, y quien la «arreglara» a `'Active'`
    // cambiaría el comportamiento sin querer.
    final principal = lineas.first;
    if (principal.msisdn.isNotEmpty) {
      final estado = await CallNativeCode.iniciarMonitoreo(principal.msisdn);
      // Solo en debug: es el número de teléfono del cliente.
      if (kDebugMode) {
        debugPrint('📲 Monitoreo para ${principal.msisdn}: $estado');
      }
    }
    if (!mounted) return;

    setState(() {
      _nombre = nombre;
      _lineas = lineas;
      _cargando = false;
      _falloCarga = false;
    });
  }

  Future<void> _pagar(_Linea linea, TipoOperacion operacion) async {
    final ofertaId = int.tryParse(linea.ofertaId) ?? 0;
    await PaymentFlow.iniciar(
      context,
      iccid: linea.iccid,
      msisdn: linea.msisdn,
      ofertaActualId: ofertaId,
      ofertaNuevaId: ofertaId,
      monto: linea.precio,
      operacion: operacion,
    );
  }

  void _irAOfertas(_Linea linea) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Entra al catálogo de recargas con esta línea ya elegida.
        builder: (_) => MenuScreen(msisdnInicial: linea.msisdn),
      ),
    );
  }

  Future<bool> _confirmarSalida() async {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
      return false;
    }

    final salir = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Deseas cerrar sesión y salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (salir == true) {
      await SessionManager.logout();
      AuthService.cerrarSesion();
      if (!mounted) return false;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmarSalida();
      },
      child: BaseScaffold(
        scaffoldKey: _scaffoldKey,
        title: 'Inicio',
        rutaActual: '/home',
        body: _cargando
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _cargar,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    _banner(),
                    const SizedBox(height: 20),
                    if (_falloCarga)
                      _errorDeCarga()
                    else if (_lineas.isEmpty)
                      _sinLineas()
                    else
                      ..._tarjetas(),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        '© 2026 TECOMNET · Movilidad',
                        style: TextStyle(
                          color: TecomnetTheme.tintaSuave,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _banner() {
    final cuantas = _lineas.length;

    return Container(
      decoration: BoxDecoration(
        gradient: TecomnetTheme.degradadoBanner,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.smartphone_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nombre.isEmpty ? 'Hola' : 'Hola $_nombre',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cuantas == 1
                      ? 'Este es el resumen de tu línea y tu consumo.'
                      : 'Este es el resumen de tus líneas y tu consumo.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                if (cuantas > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cuantas == 1 ? '1 línea' : '$cuantas líneas',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _tarjetas() {
    return _lineas.map((linea) {
      return LineCard(
        plan: linea.plan,
        msisdn: linea.msisdn,
        mbUsados: linea.mbUsados,
        mbDisponibles: linea.mbDisponibles,
        vigencia: linea.vigencia,
        esRecarga: linea.esRecarga,
        onRecargar: () => _irAOfertas(linea),
        // Solo los planes (mensual y anual) se renuevan; una recarga se
        // vuelve a comprar desde el botón Recarga.
        onRenovar: linea.esRecarga
            ? null
            : () => _pagar(linea, TipoOperacion.Renovacion),
      );
    }).toList();
  }

  /// Distinto de _sinLineas: aquí no sabemos qué tiene el cliente, solo que no
  /// pudimos preguntarlo. Se invita a reintentar, que es lo accionable.
  Widget _errorDeCarga() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: TecomnetTheme.panelTarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TecomnetTheme.panelBorde),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 40,
            color: TecomnetTheme.tintaSuave,
          ),
          const SizedBox(height: 14),
          const Text(
            'No pudimos cargar tu información',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TecomnetTheme.tintaFuerte,
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Revisa tu conexión y desliza hacia abajo para reintentar. '
            'Si sigue igual, vuelve a iniciar sesión.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TecomnetTheme.tintaMedia,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          TextButton.icon(
            onPressed: _cargar,
            icon: const Icon(Icons.refresh_rounded, size: 19),
            label: const Text('Reintentar'),
            style: TextButton.styleFrom(
              foregroundColor: TecomnetTheme.azulMarca,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sinLineas() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 24),
      decoration: BoxDecoration(
        color: TecomnetTheme.panelTarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TecomnetTheme.panelBorde),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.sim_card_outlined,
            size: 40,
            color: TecomnetTheme.tintaSuave,
          ),
          SizedBox(height: 14),
          Text(
            'No encontramos líneas asociadas a tu cuenta',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TecomnetTheme.tintaMedia,
              fontSize: 14.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
