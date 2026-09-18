import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/widgets/refill_row.dart';
import 'package:movilidad_celulares/widgets/line_selector.dart';
import 'package:movilidad_celulares/widgets/tecomnet_widgets.dart';

class RefillsScreen extends StatefulWidget {
  const RefillsScreen({super.key});

  @override
  State<RefillsScreen> createState() => _RefillsScreenState();
}

class _RefillsScreenState extends State<RefillsScreen> {
  bool _cargando = true;
  List<Map<String, dynamic>> _recargas = [];

  /// La consulta falló, que no es lo mismo que no tener recargas.
  bool _falloCarga = false;

  DateTime? _desde;
  DateTime? _hasta;

  /// MSISDN seleccionado, o null para «Todas las líneas».
  String? _linea;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (mounted) setState(() => _cargando = true);

    final clienteId = AuthService.clienteId;
    if (clienteId == null) {
      // Sin cliente no se puede ni preguntar: es un fallo, no una lista vacía.
      if (!mounted) return;
      setState(() {
        _recargas = [];
        _cargando = false;
        _falloCarga = true;
      });
      return;
    }

    final recargas = await AuthService.obtenerRecargas(clienteId);
    if (!mounted) return;
    setState(() {
      // El API las devuelve de la más vieja a la más nueva; en un historial se
      // espera lo contrario, y con decenas de recargas la última quedaba al
      // fondo de la lista.
      _recargas = [...?recargas]..sort(_masNuevaPrimero);
      _cargando = false;
      _falloCarga = recargas == null;
    });
  }

  /// Líneas que aparecen en el historial, en orden de aparición.
  ///
  /// Se derivan de las propias recargas en vez de pedir el tablero: así el
  /// filtro solo ofrece líneas que de verdad tienen movimientos.
  List<String> get _lineasDisponibles {
    final vistas = <String>{};
    for (final r in _recargas) {
      final m = r['MSISDN']?.toString() ?? '';
      if (m.isNotEmpty) vistas.add(m);
    }
    return vistas.toList();
  }

  /// Orden del historial: la más reciente arriba. Las que traen una fecha que
  /// no se puede leer van al final, para no desplazar a las que sí la tienen.
  int _masNuevaPrimero(Map<String, dynamic> a, Map<String, dynamic> b) {
    final fa = _fechaDe(a);
    final fb = _fechaDe(b);
    if (fa == null && fb == null) return 0;
    if (fa == null) return 1;
    if (fb == null) return -1;
    return fb.compareTo(fa);
  }

  /// Fecha de la recarga, o null si no se puede interpretar.
  DateTime? _fechaDe(Map<String, dynamic> recarga) =>
      DateTime.tryParse(recarga['FechaRecarga']?.toString() ?? '');

  /// Filtro por rango, inclusivo en ambos extremos.
  List<Map<String, dynamic>> get _filtradas {
    if (!_hayFiltro) return _recargas;

    return _recargas.where((r) {
      if (_linea != null && r['MSISDN']?.toString() != _linea) return false;
      if (_desde == null && _hasta == null) return true;

      final fecha = _fechaDe(r);
      if (fecha == null) return false;
      final dia = DateTime(fecha.year, fecha.month, fecha.day);
      if (_desde != null) {
        final d = DateTime(_desde!.year, _desde!.month, _desde!.day);
        if (dia.isBefore(d)) return false;
      }
      if (_hasta != null) {
        final h = DateTime(_hasta!.year, _hasta!.month, _hasta!.day);
        if (dia.isAfter(h)) return false;
      }
      return true;
    }).toList();
  }

  bool get _hayFiltro => _desde != null || _hasta != null || _linea != null;

  /// «25/08/26, 6:11 p.m.», como en el portal web.
  String _fechaLarga(Map<String, dynamic> recarga) {
    final f = _fechaDe(recarga);
    if (f == null) return recarga['FechaRecarga']?.toString() ?? '';

    final dd = f.day.toString().padLeft(2, '0');
    final mm = f.month.toString().padLeft(2, '0');
    final aa = (f.year % 100).toString().padLeft(2, '0');

    final sufijo = f.hour < 12 ? 'a.m.' : 'p.m.';
    var hora = f.hour % 12;
    if (hora == 0) hora = 12;
    final min = f.minute.toString().padLeft(2, '0');

    return '$dd/$mm/$aa, $hora:$min $sufijo';
  }

  String _importe(Map<String, dynamic> recarga) {
    final total = (recarga['Total'] as num?)?.toDouble();
    if (total == null) return '—';
    return '\$${total.toStringAsFixed(2)}';
  }

  void _facturar(Map<String, dynamic> recarga) {
    // PENDIENTE (conexión): aquí va la llamada de facturación.
    showNotice(
      context,
      'La facturación estará disponible próximamente',
      color: TecomnetTheme.azulMarca,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Mis recargas',
      rutaActual: '/refills',
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargar,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                children: [_tarjetaHistorial()],
              ),
            ),
    );
  }

  Widget _tarjetaHistorial() {
    final filtradas = _filtradas;

    return Container(
      decoration: BoxDecoration(
        color: TecomnetTheme.panelTarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TecomnetTheme.panelBorde),
        boxShadow: [
          BoxShadow(
            color: TecomnetTheme.tintaFuerte.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _encabezado(),
          const SizedBox(height: 20),
          _filtros(),
          const SizedBox(height: 14),
          _conteo(filtradas.length),
          const SizedBox(height: 16),
          if (filtradas.isEmpty)
            EmptyPanel(
              // El primer caso es un fallo de red o de sesión: decir «aún no
              // tienes recargas» ahí haría creer al cliente que perdió su
              // historial.
              mensaje: _falloCarga
                  ? 'No pudimos cargar tu historial. Revisa tu conexión '
                        'o vuelve a iniciar sesión.'
                  : !_hayFiltro
                  ? 'Aún no tienes recargas registradas'
                  : _linea != null && _desde == null && _hasta == null
                  ? 'Esta línea no tiene recargas registradas'
                  : 'No hay recargas con los filtros seleccionados',
              icono: _falloCarga
                  ? Icons.cloud_off_rounded
                  : Icons.receipt_long_outlined,
            )
          else
            ...filtradas.map(_fila),
        ],
      ),
    );
  }

  Widget _encabezado() {
    return Row(
      children: [
        const Icon(
          Icons.receipt_long_outlined,
          size: 22,
          color: TecomnetTheme.azulMarca,
        ),
        const SizedBox(width: 10),
        const Text(
          'Historial de recargas',
          style: TextStyle(
            color: TecomnetTheme.tintaFuerte,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  /// Fichas de línea. Solo aparecen si hay más de una: con una sola no hay
  /// nada que filtrar y serían ruido.
  Widget _fichasLinea() {
    final lineas = _lineasDisponibles;
    if (lineas.length < 2) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _ficha('Todas', _linea == null, () => setState(() => _linea = null)),
          ...lineas.map(
            (m) => _ficha(m, _linea == m, () => setState(() => _linea = m)),
          ),
        ],
      ),
    );
  }

  Widget _ficha(String texto, bool activa, VoidCallback onTap) {
    return Material(
      color: activa ? TecomnetTheme.azulMarca : TecomnetTheme.panelFondo,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: activa
                  ? TecomnetTheme.azulMarca
                  : TecomnetTheme.panelBorde,
            ),
          ),
          child: Text(
            texto,
            style: TextStyle(
              color: activa ? Colors.white : TecomnetTheme.tintaMedia,
              fontSize: 13.5,
              fontWeight: activa ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _filtros() {
    return Column(
      children: [
        _fichasLinea(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: DateField(
                etiqueta: 'Desde',
                valor: _desde,
                onCambio: (f) => setState(() => _desde = f),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DateField(
                etiqueta: 'Hasta',
                valor: _hasta,
                onCambio: (f) => setState(() => _hasta = f),
              ),
            ),
          ],
        ),
        if (_hayFiltro) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: () => setState(() {
                _desde = null;
                _hasta = null;
                _linea = null;
              }),
              icon: const Icon(Icons.cancel_outlined, size: 18),
              label: const Text('Limpiar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: TecomnetTheme.azulMarca,
                side: const BorderSide(
                  color: TecomnetTheme.azulMarca,
                  width: 1.3,
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _conteo(int mostradas) {
    final total = _recargas.length;
    final texto = mostradas == total
        ? '$total ${total == 1 ? 'recarga' : 'recargas'}'
        : '$mostradas de $total recargas';

    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        texto,
        style: const TextStyle(color: TecomnetTheme.tintaSuave, fontSize: 13),
      ),
    );
  }

  Widget _fila(Map<String, dynamic> recarga) {
    return RefillRow(
      oferta: (recarga['Oferta'] ?? '—').toString(),
      fecha: _fechaLarga(recarga),
      linea: (recarga['MSISDN'] ?? '').toString(),
      total: _importe(recarga),
      metodo: (recarga['NombreMetodo'] ?? '').toString(),
      onFacturar: () => _facturar(recarga),
    );
  }
}
