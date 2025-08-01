import 'package:flutter/material.dart';

class UpdatePlanScreen extends StatefulWidget {
  const UpdatePlanScreen({super.key});

  @override
  State<UpdatePlanScreen> createState() => _UpdatePlanScreenState();
}

class _UpdatePlanScreenState extends State<UpdatePlanScreen> {
  String tipoPlanActual = 'pospago';
  String planActual = 'Plan Premium';
  int? planSeleccionadoIndex;
  String vistaActual = 'plan';

  final List<Map<String, String>> planesPrepago = [
    {
      'nombre': 'Paquete Alcance',
      'descripcion': '1GB, 5000 min, 1000 SMS, Vigencia 7 días',
    },
    {
      'nombre': 'Paquete Básico',
      'descripcion': '2GB, 3000 min, Vigencia 15 días',
    },
  ];

  final List<Map<String, String>> planesPospago = [
    {
      'nombre': 'Plan Premium',
      'descripcion': '5GB, Minutos/SMS ilimitados, Vigencia 30 días',
    },
    {
      'nombre': 'Plan Plus',
      'descripcion': '10GB, Roaming incluido, Vigencia 30 días',
    },
    {
      'nombre': 'Plan Básico Pospago',
      'descripcion': '3GB, 2000 min, Vigencia 30 días',
    },
  ];

  final List<Map<String, String>> planesPagoAnticipado = [
    {
      'nombre': 'Pago Anticipado 1',
      'descripcion': 'Renueva antes de la fecha de vencimiento con descuento',
    },
    {
      'nombre': 'Pago Anticipado 2',
      'descripcion': 'Pago anticipado semestral con beneficios extra',
    },
  ];

  final List<Map<String, String>> planesPagoRecurrente = [
    {
      'nombre': 'Pago Recurrente Mensual',
      'descripcion': 'Se cobra automáticamente cada mes',
    },
    {
      'nombre': 'Pago Recurrente Semanal',
      'descripcion': 'Se cobra automáticamente cada semana',
    },
  ];

  List<Map<String, String>> obtenerPlanesSegunVista() {
    switch (vistaActual) {
      case 'prepago':
        return planesPrepago;
      case 'pago_anticipado':
        return planesPagoAnticipado;
      case 'pospago':
        return planesPospago.where((plan) => plan['nombre'] != planActual).toList();
      case 'pago_recurrente':
        return planesPagoRecurrente;
      case 'plan':
      default:
        return [
          {'nombre': planActual, 'descripcion': 'Este es tu plan actual.'},
        ];
    }
  }

  void cambiarVista(String nuevaVista) {
    setState(() {
      vistaActual = nuevaVista;
      planSeleccionadoIndex = null;
    });
  }

  void seleccionarPlan(int index) {
    setState(() {
      planSeleccionadoIndex = index;
    });
    final plan = obtenerPlanesSegunVista()[index];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Seleccionaste: ${plan['nombre']}')),
    );
  }

  void confirmarPlan() {
    if (planSeleccionadoIndex == null) return;
    final plan = obtenerPlanesSegunVista()[planSeleccionadoIndex!];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Plan actualizado a "${plan['nombre']}" (simulado)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final planes = obtenerPlanesSegunVista();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Plan'),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        color: Colors.blue[50],
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona el tipo de plan actual:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: tipoPlanActual,
              items: const [
                DropdownMenuItem(value: 'prepago', child: Text('Prepago')),
                DropdownMenuItem(value: 'pospago', child: Text('Pospago')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    tipoPlanActual = value;
                    planActual = value == 'pospago' ? 'Plan Premium' : 'Paquete Alcance';
                    vistaActual = 'plan';
                    planSeleccionadoIndex = null;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => cambiarVista('plan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vistaActual == 'plan' ? Colors.blue : Colors.blue[100],
                    foregroundColor: vistaActual == 'plan' ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Plan'),
                ),
                if (tipoPlanActual == 'prepago') ...[
                  ElevatedButton(
                    onPressed: () => cambiarVista('prepago'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vistaActual == 'prepago' ? Colors.blue : Colors.blue[200],
                      foregroundColor: vistaActual == 'prepago' ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Prepago'),
                  ),
                  ElevatedButton(
                    onPressed: () => cambiarVista('pago_anticipado'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vistaActual == 'pago_anticipado'
                          ? const Color.fromARGB(255, 104, 170, 224)
                          : const Color.fromARGB(255, 104, 200, 224),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Pago Anticipado'),
                  ),
                ] else if (tipoPlanActual == 'pospago') ...[
                  ElevatedButton(
                    onPressed: () => cambiarVista('pospago'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vistaActual == 'pospago' ? Colors.blue : Colors.blue[200],
                      foregroundColor: vistaActual == 'pospago' ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Pospago'),
                  ),
                  ElevatedButton(
                    onPressed: () => cambiarVista('pago_recurrente'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vistaActual == 'pago_recurrente'
                          ? const Color.fromARGB(255, 104, 170, 224)
                          : const Color.fromARGB(255, 104, 200, 224),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Pago Recurrente'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
            Text(
              vistaActual == 'plan'
                  ? 'Tu plan actual:'
                  : vistaActual == 'prepago'
                      ? 'Planes Prepago disponibles:'
                      : vistaActual == 'pago_anticipado'
                          ? 'Opciones de Pago Anticipado:'
                          : vistaActual == 'pospago'
                              ? 'Planes Pospago disponibles:'
                              : 'Opciones de Pago Recurrente:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: planes.isEmpty
                  ? const Center(child: Text('No hay planes disponibles'))
                  : PageView.builder(
                      controller: PageController(viewportFraction: 0.85),
                      itemCount: planes.length,
                      itemBuilder: (context, index) {
                        final plan = planes[index];
                        final seleccionado = planSeleccionadoIndex == index;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plan['nombre']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(plan['descripcion']!),
                                  const Spacer(),
                                  if (vistaActual != 'plan')
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () => seleccionarPlan(index),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: seleccionado ? Colors.green : Colors.blue,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          minimumSize: const Size(double.infinity, 40),
                                        ),
                                        child: Text(
                                          seleccionado ? 'Seleccionado' : 'Lo quiero',
                                          style: const TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
