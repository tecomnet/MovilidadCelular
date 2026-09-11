import 'package:flutter/material.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';

/// Separa millares con coma: 45450 → "45,450".
String thousandsSeparator(num valor) {
  final entero = valor.round().toString();
  return entero.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]},',
  );
}

/// Tarjeta de una oferta en el catálogo de recargas.
///
/// Cabecera oscura con el nombre, franja de precio, tira de servicios
/// incluidos y el detalle de datos, minutos y SMS.
class OfferCard extends StatelessWidget {
  final String nombre;
  final double precio;

  /// OJO: el campo se llama `DatosMB` en la API pero viene en **gigabytes**.
  /// Verificado contra el catálogo: STAR4G=4 → «4 GB», PLUS-NR=12 → «12 GB».
  final num datosGb;

  final int validezDias;
  final int minutos;
  final int sms;

  /// Texto bajo el precio: RECARGA, MES, AÑO…
  final String periodo;

  final VoidCallback onSeleccionar;
  final String textoBoton;

  const OfferCard({
    super.key,
    required this.nombre,
    required this.precio,
    required this.datosGb,
    required this.validezDias,
    required this.minutos,
    required this.sms,
    required this.onSeleccionar,
    this.periodo = 'RECARGA',
    this.textoBoton = 'Recargar',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: TecomnetTheme.tintaFuerte.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _cabecera(),
            _precio(),
            _servicios(),
            _detalle(),
          ],
        ),
      ),
    );
  }

  Widget _cabecera() {
    return Container(
      width: double.infinity,
      color: TecomnetTheme.tintaFuerte,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Text(
        nombre.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _precio() {
    // Sin centavos si el precio es redondo: «$160» en vez de «$160.00».
    final texto = precio == precio.roundToDouble()
        ? precio.round().toString()
        : precio.toStringAsFixed(2);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [TecomnetTheme.azulProfundo, TecomnetTheme.azulMarca],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.only(top: 18, bottom: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '\$',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                texto,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '/$periodo',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _servicios() {
    return Container(
      width: double.infinity,
      color: TecomnetTheme.azulSuave,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sensors_rounded,
            size: 17,
            color: TecomnetTheme.azulMarca,
          ),
          const SizedBox(width: 8),
          Text(
            'Datos · Llamadas · SMS',
            style: TextStyle(
              color: TecomnetTheme.azulProfundo,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detalle() {
    return Container(
      width: double.infinity,
      color: TecomnetTheme.panelTarjeta,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Text(
                  '$datosGb GB',
                  style: const TextStyle(
                    color: TecomnetTheme.tintaFuerte,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '|',
                    style: TextStyle(
                      color: TecomnetTheme.tintaSuave,
                      fontSize: 21,
                    ),
                  ),
                ),
                Text(
                  '$validezDias días',
                  style: const TextStyle(
                    color: TecomnetTheme.tintaFuerte,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _incluido(Icons.phone_outlined, '${thousandsSeparator(minutos)} min'),
              const SizedBox(width: 20),
              _incluido(
                Icons.chat_bubble_outline_rounded,
                '${thousandsSeparator(sms)} SMS',
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: onSeleccionar,
              style: OutlinedButton.styleFrom(
                foregroundColor: TecomnetTheme.azulMarca,
                side: const BorderSide(
                  color: TecomnetTheme.azulMarca,
                  width: 1.4,
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(textoBoton),
            ),
          ),
        ],
      ),
    );
  }

  Widget _incluido(IconData icono, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 15, color: TecomnetTheme.tintaSuave),
        const SizedBox(width: 6),
        Text(
          texto,
          style: const TextStyle(
            color: TecomnetTheme.tintaMedia,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
