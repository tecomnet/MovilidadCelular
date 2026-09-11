import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';

/// Tarjeta de una línea en el panel de inicio: consumo, vigencia y acciones.
class LineCard extends StatelessWidget {
  final String plan;
  final String msisdn;

  /// Megas ya consumidos y disponibles. El total es la suma de ambos.
  final double mbUsados;
  final double mbDisponibles;

  /// Fecha de vencimiento ya formateada; vacío si no aplica.
  final String vigencia;

  /// Distingue la insignia: RECARGA (tipo 1) frente a PLAN (tipos 2 y 3).
  /// Se decide con el campo `Tipo` de la API, no con `EsPrepago`.
  final bool esRecarga;

  final VoidCallback onRecargar;

  /// Solo los planes renovables lo reciben; en una recarga va `null` y el
  /// botón no aparece.
  final VoidCallback? onRenovar;

  const LineCard({
    super.key,
    required this.plan,
    required this.msisdn,
    required this.mbUsados,
    required this.mbDisponibles,
    required this.vigencia,
    required this.esRecarga,
    required this.onRecargar,
    this.onRenovar,
  });

  double get _total => mbUsados + mbDisponibles;

  /// Proporción disponible. Sin datos contratados se muestra el aro vacío.
  double get _proporcionDisponible =>
      _total > 0 ? (mbDisponibles / _total).clamp(0.0, 1.0) : 0.0;

  int get _porcentajeUsado =>
      _total > 0 ? ((mbUsados / _total) * 100).round() : 0;

  static String _gb(double mb) => '${(mb / 1024).toStringAsFixed(2)} GB';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _encabezado(),
          const SizedBox(height: 6),
          _numero(),
          const SizedBox(height: 20),
          Center(child: _donut()),
          const SizedBox(height: 20),
          const Divider(color: TecomnetTheme.panelBorde, height: 1),
          const SizedBox(height: 16),
          _resumen(),
          const SizedBox(height: 18),
          Center(child: _vigencia()),
          const SizedBox(height: 18),
          _acciones(),
        ],
      ),
    );
  }

  Widget _encabezado() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            plan,
            style: const TextStyle(
              color: TecomnetTheme.tintaFuerte,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 10),
        _insignia(),
      ],
    );
  }

  Widget _insignia() {
    final esPlan = !esRecarga;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: esPlan ? TecomnetTheme.azulSuave : TecomnetTheme.verdeSuave,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        esPlan ? 'PLAN' : 'RECARGA',
        style: TextStyle(
          color: esPlan ? TecomnetTheme.azulMarca : TecomnetTheme.verde,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _numero() {
    return Row(
      children: [
        const Icon(
          Icons.phone_outlined,
          size: 15,
          color: TecomnetTheme.tintaSuave,
        ),
        const SizedBox(width: 6),
        Text(
          msisdn.isEmpty ? '—' : msisdn,
          style: const TextStyle(
            color: TecomnetTheme.tintaMedia,
            fontSize: 14.5,
          ),
        ),
      ],
    );
  }

  Widget _donut() {
    return CircularPercentIndicator(
      radius: 82,
      lineWidth: 17,
      animation: true,
      animationDuration: 700,
      percent: _proporcionDisponible,
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: TecomnetTheme.azulMarca,
      backgroundColor: TecomnetTheme.azulClaro.withValues(alpha: 0.35),
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.language_rounded,
            color: TecomnetTheme.azulMarca,
            size: 24,
          ),
          const SizedBox(height: 6),
          const Text(
            'DISPONIBLE',
            style: TextStyle(
              color: TecomnetTheme.tintaSuave,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
          Text(
            _gb(mbDisponibles),
            style: const TextStyle(
              color: TecomnetTheme.tintaFuerte,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'de ${_gb(_total)}',
            style: const TextStyle(
              color: TecomnetTheme.tintaSuave,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resumen() {
    return Row(
      children: [
        Expanded(child: _dato('$_porcentajeUsado%', 'USADO')),
        const _SeparadorVertical(),
        Expanded(child: _dato(_gb(mbDisponibles), 'DISPONIBLE')),
        const _SeparadorVertical(),
        Expanded(child: _dato(_gb(_total), 'TOTAL')),
      ],
    );
  }

  Widget _dato(String valor, String etiqueta) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            valor,
            style: const TextStyle(
              color: TecomnetTheme.tintaFuerte,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          etiqueta,
          style: const TextStyle(
            color: TecomnetTheme.tintaSuave,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
          ),
        ),
      ],
    );
  }

  Widget _vigencia() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: TecomnetTheme.panelFondo,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: TecomnetTheme.panelBorde),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 15,
            color: TecomnetTheme.tintaSuave,
          ),
          const SizedBox(width: 8),
          const Text(
            'Vigencia ',
            style: TextStyle(color: TecomnetTheme.tintaMedia, fontSize: 13.5),
          ),
          Text(
            vigencia.isEmpty ? '—' : vigencia,
            style: const TextStyle(
              color: TecomnetTheme.tintaFuerte,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _acciones() {
    // Una recarga no se renueva: en ese caso el botón de recarga ocupa el ancho.
    final puedeRenovar = onRenovar != null;

    if (!puedeRenovar) {
      return SizedBox(
        width: double.infinity,
        child: _botonSecundario('Recarga', Icons.bolt_rounded, onRecargar),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _botonPrimario('Renovar', Icons.autorenew_rounded, onRenovar!),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _botonSecundario('Recarga', Icons.bolt_rounded, onRecargar),
        ),
      ],
    );
  }

  Widget _botonPrimario(String texto, IconData icono, VoidCallback onTap) {
    return SizedBox(
      height: 46,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icono, size: 18),
        label: Text(texto),
        style: ElevatedButton.styleFrom(
          backgroundColor: TecomnetTheme.azulProfundo,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _botonSecundario(String texto, IconData icono, VoidCallback onTap) {
    return SizedBox(
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icono, size: 18),
        label: Text(texto),
        style: OutlinedButton.styleFrom(
          foregroundColor: TecomnetTheme.azulMarca,
          side: const BorderSide(color: TecomnetTheme.azulMarca, width: 1.4),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class _SeparadorVertical extends StatelessWidget {
  const _SeparadorVertical();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: TecomnetTheme.panelBorde,
    );
  }
}
