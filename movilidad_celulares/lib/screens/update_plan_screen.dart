import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/widgets/payment_webview.dart';

class UpdatePlanScreen extends StatefulWidget {
  const UpdatePlanScreen({super.key});

  @override
  State<UpdatePlanScreen> createState() => _UpdatePlanScreenState();
}

class _UpdatePlanScreenState extends State<UpdatePlanScreen> {
  String tipoPlanActual = 'prepago';
  int? planSeleccionadoIndex;
  String vistaActual = 'prepago';
  bool cargando = false;

  int obtenerPrecioDelPlan(Map<String, dynamic> plan) {
    switch (vistaActual) {
      case 'prepago':
        return ((plan['PrecioMensual'] ?? 0) * 100).toInt();
      case 'pago_recurrente':
        return ((plan['PrecioRecurrente'] ?? 0) * 100).toInt();
      case 'pago_anticipado':
        return ((plan['PrecioAnual'] ?? 0) * 100).toInt();
      default:
        return 0;
    }
  }

  List<Map<String, dynamic>> planesDisponibles = [];

  final Map<String, String> nombresTipos = {
    'prepago': 'Recarga',
    'pago_recurrente': 'Plan Mensual',
    'pago_anticipado': 'Plan Anual',
  };

  final Map<String, int> tipoPlanIndices = {
    'prepago': 1,
    'pago_recurrente': 2,
    'pago_anticipado': 3,
  };

  @override
  void initState() {
    super.initState();
    cargarPlanes();
  }

  Future<void> cargarPlanes() async {
    setState(() {
      cargando = true;
    });

    final tipo = tipoPlanIndices[vistaActual] ?? 1;
    final data = await AuthService.obtenerOfertasPorTipo(tipo);

    setState(() {
      planesDisponibles = data ?? [];
      cargando = false;
    });
  }

  void cambiarVista(String nuevaVista) {
    setState(() {
      vistaActual = nuevaVista;
      planSeleccionadoIndex = null;
    });
    cargarPlanes();
  }

  @override
  Widget build(BuildContext context) {
    final botonesOpciones = [
      'prepago',
      'pago_recurrente',
      'pago_anticipado',
    ].where((tipo) => tipo != tipoPlanActual).toList();

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
            const Text('Tipo de plan actual:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: tipoPlanActual,
              items: const [
                DropdownMenuItem(value: 'prepago', child: Text('Recarga')),
                DropdownMenuItem(
                  value: 'pago_recurrente',
                  child: Text('Plan Mensual'),
                ),
                DropdownMenuItem(
                  value: 'pago_anticipado',
                  child: Text('Plan Anual'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    tipoPlanActual = value;
                    vistaActual = value;
                    planSeleccionadoIndex = null;
                  });
                  cargarPlanes();
                }
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: botonesOpciones
                  .map(
                    (tipo) => ElevatedButton(
                      onPressed: () => cambiarVista(tipo),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vistaActual == tipo
                            ? Colors.blue
                            : Colors.blue[200],
                      ),
                      child: Text(nombresTipos[tipo]!),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Opciones disponibles (${nombresTipos[vistaActual]})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            cargando
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: planesDisponibles.isEmpty
                        ? const Center(
                            child: Text('No hay planes disponibles.'),
                          )
                        : PageView.builder(
                            controller: PageController(viewportFraction: 0.85),
                            itemCount: planesDisponibles.length,
                            itemBuilder: (context, index) {
                              final plan = planesDisponibles[index];
                              final seleccionado =
                                  planSeleccionadoIndex == index;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plan['Oferta'] ?? 'Plan sin nombre',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          plan['Descripcion'] ??
                                              'Sin descripción',
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Precio: \$${(obtenerPrecioDelPlan(plan) / 100).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),

                                        const Spacer(),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              final plan =
                                                  planesDisponibles[index];
                                              final orderIdTec =
                                                  await AuthService.generarOrderID(
                                                    iccid:
                                                        'HJFDKJHSF98743978', 
                                                    ofertaActualId:
                                                        plan['OfertaID']
                                                            .toString(),
                                                    ofertaNuevaId:
                                                        plan['OfertaID']
                                                            .toString(),
                                                    monto:
                                                        plan['PrecioRecurrente']
                                                            .toString(),
                                                  );

                                              if (orderIdTec == null) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Error al generar OrderID",
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }

                                              final token =
                                                  await AuthService.obtenerTokenRecargas(
                                                    "h.martinez@tecomnet.mx",
                                                    "api-113f2717-c412-48d1-8da3-d3df93b2954c-29vpbp",
                                                  );

                                              if (token == null) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Error al obtener token",
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }

                                              final link =
                                                  await AuthService.obtenerLinkDePago(
                                                    token: token,
                                                    amount:
                                                        (plan['PrecioRecurrente'] *
                                                                100)
                                                            .toInt(),
                                                    description:
                                                        plan['Oferta'] ??
                                                        'Renovación del plan',
                                                    orderId: orderIdTec,
                                                  );

                                              if (link == null) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Error al generar link de pago",
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }

                                              if (context.mounted) {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (BuildContext context) {
                                                    final screenSize =
                                                        MediaQuery.of(
                                                          context,
                                                        ).size;
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                      insetPadding:
                                                          const EdgeInsets.all(
                                                            10,
                                                          ),
                                                      child: SizedBox(
                                                        width:
                                                            screenSize.width *
                                                            0.9,
                                                        height:
                                                            screenSize.height *
                                                            0.8,
                                                        child: WebViewScreen(
                                                          url: link,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: seleccionado
                                                  ? Colors.green
                                                  : Colors.blue,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Lo quiero'),
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
