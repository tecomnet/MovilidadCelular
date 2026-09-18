import 'package:flutter/material.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';

/// Una línea del cliente, tal como llega del tablero.
class ClientLine {
  final String plan;
  final String msisdn;
  final String iccid;
  final String ofertaId;

  const ClientLine({
    required this.plan,
    required this.msisdn,
    required this.iccid,
    required this.ofertaId,
  });

  factory ClientLine.desde(Map<String, dynamic> fila) => ClientLine(
    plan: (fila['Oferta'] ?? 'Plan').toString().toUpperCase(),
    msisdn: fila['MSISDN']?.toString() ?? '',
    iccid: fila['ICCID']?.toString() ?? '',
    ofertaId: fila['OfertaID']?.toString() ?? '',
  );
}

/// Primer paso de recargar y de actualizar plan: elegir sobre qué línea.
///
/// Es el mismo paso en los dos flujos, solo cambia el título.
class LineSelector extends StatelessWidget {
  final String titulo;
  final List<ClientLine> lineas;
  final ValueChanged<ClientLine> onSeleccionar;

  const LineSelector({
    super.key,
    required this.titulo,
    required this.lineas,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      children: [
        Text(
          titulo,
          style: const TextStyle(
            color: TecomnetTheme.tintaFuerte,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 18),
        ...lineas.map(_tarjeta),
      ],
    );
  }

  Widget _tarjeta(ClientLine linea) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TecomnetTheme.panelTarjeta,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TecomnetTheme.panelBorde),
        boxShadow: [
          BoxShadow(
            color: TecomnetTheme.tintaFuerte.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            linea.plan,
            style: const TextStyle(
              color: TecomnetTheme.tintaFuerte,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 15,
                color: TecomnetTheme.tintaSuave,
              ),
              const SizedBox(width: 6),
              Text(
                linea.msisdn.isEmpty ? '—' : linea.msisdn,
                style: const TextStyle(
                  color: TecomnetTheme.tintaMedia,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => onSeleccionar(linea),
              style: ElevatedButton.styleFrom(
                backgroundColor: TecomnetTheme.azulProfundo,
                foregroundColor: Colors.white,
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Seleccionar'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Botón de retroceso entre pasos: «← Cambiar de línea», «← Otro tipo de plan».
class StepBackButton extends StatelessWidget {
  final String texto;
  final VoidCallback onTap;

  const StepBackButton({super.key, required this.texto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.arrow_back_rounded, size: 18),
        label: Text(texto),
        style: OutlinedButton.styleFrom(
          foregroundColor: TecomnetTheme.azulMarca,
          side: const BorderSide(color: TecomnetTheme.azulMarca, width: 1.3),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

/// Encabezado de paso: título grande y la línea sobre la que se opera.
class StepHeader extends StatelessWidget {
  final String titulo;
  final String? msisdn;

  const StepHeader({super.key, required this.titulo, this.msisdn});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            color: TecomnetTheme.tintaFuerte,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (msisdn != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Text(
                'Línea: ',
                style: TextStyle(
                  color: TecomnetTheme.tintaMedia,
                  fontSize: 14.5,
                ),
              ),
              Text(
                msisdn!.isEmpty ? '—' : msisdn!,
                style: const TextStyle(
                  color: TecomnetTheme.tintaFuerte,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Tarjeta de elección de tipo de plan (mensual, prepago, anual).
class PlanTypeCard extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String descripcion;
  final VoidCallback onTap;

  const PlanTypeCard({
    super.key,
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: const Color(0xFFE8EEF6),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                Icon(icono, size: 38, color: TecomnetTheme.azulMarca),
                const SizedBox(height: 14),
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: TecomnetTheme.tintaFuerte,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  descripcion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: TecomnetTheme.tintaMedia,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Estado vacío reutilizable del panel.
class EmptyPanel extends StatelessWidget {
  final String mensaje;
  final IconData icono;

  const EmptyPanel({
    super.key,
    required this.mensaje,
    this.icono = Icons.sim_card_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 24),
      decoration: BoxDecoration(
        color: TecomnetTheme.panelTarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TecomnetTheme.panelBorde),
      ),
      child: Column(
        children: [
          Icon(icono, size: 40, color: TecomnetTheme.tintaSuave),
          const SizedBox(height: 14),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(
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
