import 'package:flutter/material.dart';
import 'package:movilidad_celulares/screens/update_plan_screen.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';

class MenuOpcionesScreen extends StatelessWidget {
  final int tipoPlan;
  final String iccidSeleccionado;
  final String ofertaActualId;

  const MenuOpcionesScreen({
    super.key,
    required this.tipoPlan,
    required this.iccidSeleccionado,
    required this.ofertaActualId,
  });

  @override
  Widget build(BuildContext context) {
    final Map<int, Map<String, dynamic>> tipos = {
      3: {
        'titulo': 'Mensual',
        'descripcion': 'Contrata un plan recurrente con pago mensual',
        'icono': Icons.calendar_month,
      },
      1: {
        'titulo': 'Recarga',
        'descripcion': 'Compra paquetes de datos de forma inmediata',
        'icono': Icons.bolt,
      },
      2: {
        'titulo': 'Anual',
        'descripcion': 'Planes con pago anticipado por 12 meses',
        'icono': Icons.workspace_premium,
      },
    };

    final tiposAlternativos =
        tipos.entries.where((e) => e.key != tipoPlan).toList();

    return BaseScaffold(
      title: '',
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 20, 89, 145),
              Color.fromARGB(255, 10, 52, 114),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tiposAlternativos.length,
          itemBuilder: (context, index) {
            final tipo = tiposAlternativos[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  tipo.value['icono'],
                  color: Colors.blueAccent,
                  size: 32,
                ),
                title: Text(
                  tipo.value['titulo'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  tipo.value['descripcion'],
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdatePlanScreen(
                        iccidSeleccionado: iccidSeleccionado,
                        tipoPlan: tipo.key,
                        ofertaActualId: ofertaActualId,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
