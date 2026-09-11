import 'package:flutter/material.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';

/// Una recarga del historial.
///
/// En web es una fila de tabla de seis columnas. En móvil no cabe, así que se
/// reordena por jerarquía: lo que identifica la recarga arriba (oferta e
/// importe), el detalle debajo y la acción al final.
class RefillRow extends StatelessWidget {
  final String oferta;
  final String fecha;
  final String linea;
  final String total;
  final String metodo;
  final VoidCallback? onFacturar;

  const RefillRow({
    super.key,
    required this.oferta,
    required this.fecha,
    required this.linea,
    required this.total,
    required this.metodo,
    this.onFacturar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TecomnetTheme.panelTarjeta,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TecomnetTheme.panelBorde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  oferta,
                  style: const TextStyle(
                    color: TecomnetTheme.tintaFuerte,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                total,
                style: const TextStyle(
                  color: TecomnetTheme.tintaFuerte,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _dato(Icons.calendar_today_outlined, fecha),
          const SizedBox(height: 6),
          _dato(Icons.phone_outlined, linea),
          const SizedBox(height: 6),
          _dato(Icons.credit_card_outlined, metodo),
          if (onFacturar != null) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton.icon(
                onPressed: onFacturar,
                icon: const Icon(Icons.receipt_long_outlined, size: 17),
                label: const Text('Facturar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: TecomnetTheme.azulMarca,
                  side: const BorderSide(
                    color: TecomnetTheme.azulMarca,
                    width: 1.3,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14.5,
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
      ),
    );
  }

  Widget _dato(IconData icono, String texto) {
    return Row(
      children: [
        Icon(icono, size: 14.5, color: TecomnetTheme.tintaSuave),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto.isEmpty ? '—' : texto,
            style: const TextStyle(
              color: TecomnetTheme.tintaMedia,
              fontSize: 13.5,
            ),
          ),
        ),
      ],
    );
  }
}

/// Campo de fecha del filtro: se ve como un input y abre el selector nativo.
class DateField extends StatelessWidget {
  final String etiqueta;
  final DateTime? valor;
  final ValueChanged<DateTime?> onCambio;

  const DateField({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.onCambio,
  });

  static String formatoCorto(DateTime f) =>
      '${f.day.toString().padLeft(2, '0')}/'
      '${f.month.toString().padLeft(2, '0')}/'
      '${f.year}';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(
            color: TecomnetTheme.tintaMedia,
            fontSize: 13.5,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            final hoy = DateTime.now();
            final elegida = await showDatePicker(
              context: context,
              initialDate: valor ?? hoy,
              firstDate: DateTime(hoy.year - 5),
              lastDate: DateTime(hoy.year + 1),
              helpText: 'Selecciona la fecha',
              cancelText: 'Cancelar',
              confirmText: 'Aceptar',
            );
            if (elegida != null) onCambio(elegida);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: TecomnetTheme.panelTarjeta,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: TecomnetTheme.panelBorde),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    valor == null ? 'dd/mm/aaaa' : formatoCorto(valor!),
                    style: TextStyle(
                      color: valor == null
                          ? TecomnetTheme.tintaSuave
                          : TecomnetTheme.tintaFuerte,
                      fontSize: 14.5,
                      fontWeight:
                          valor == null ? FontWeight.w400 : FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: TecomnetTheme.tintaSuave,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
