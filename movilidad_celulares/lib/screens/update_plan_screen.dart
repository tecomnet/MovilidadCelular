import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/widgets/payment_webview.dart';

class UpdatePlanScreen extends StatefulWidget {
  const UpdatePlanScreen({super.key});

  @override
  State<UpdatePlanScreen> createState() => _UpdatePlanScreenState();
}

class _UpdatePlanScreenState extends State<UpdatePlanScreen> {
  String tipoPlanActual = 'prepago';
  bool cargando = true;
  List<Map<String, dynamic>> planesDisponibles = [];

  final Map<String, String> nombresTipos = {
    'prepago': 'Recarga',
    'pago_recurrente': 'Plan Mensual',
    'pago_anticipado': 'Plan Anual',
  };

  
  final Map<int, String> tipoNumeroATipo = {
    2: 'prepago', 
    1: 'pago_recurrente', 
    3: 'pago_anticipado', 
  };

  int get tipoPlanActualNumero {
    return tipoNumeroATipo.entries
        .firstWhere((e) => e.value == tipoPlanActual)
        .key;
  }

  @override
  void initState() {
    super.initState();
    cargarPlanes();
  }

  Future<void> cargarPlanes() async {
    setState(() => cargando = true);

    final perfil = await AuthService.obtenerPerfil();
    final tablero = await AuthService.obtenerTablero(perfil?['ClienteId'] ?? 0);

    if (tablero != null && tablero.isNotEmpty) {
      final planActual = tablero.first;
      tipoPlanActual = tipoNumeroATipo[planActual['Tipo']] ?? 'prepago';
    }

    List<Map<String, dynamic>> todasOfertas = [];
    for (var tipo in [1, 2, 3]) {
      final ofertas = await AuthService.obtenerOfertasPorTipo(tipo);
      if (ofertas != null) todasOfertas.addAll(ofertas);
    }

    setState(() {
      planesDisponibles = todasOfertas;
      cargando = false;
    });
  }

  int obtenerPrecioDelPlan(Map<String, dynamic> plan) {
    switch (plan['Tipo']) {
      case 2:
        return ((plan['PrecioMensual'] ?? 0) * 100).toInt();
      case 1:
        return ((plan['PrecioRecurrente'] ?? 0) * 100).toInt();
      case 3:
        return ((plan['PrecioAnual'] ?? 0) * 100).toInt();
      default:
        return 0;
    }
  }

  List<Map<String, dynamic>> get planesAlternativos {
    return planesDisponibles
        .where((p) => p['Tipo'] != tipoPlanActualNumero)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Actualizar Plan',
      body: Container(
        color: const Color.fromARGB(255, 10, 52, 114),
        padding: const EdgeInsets.all(24),
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu plan actual: ${nombresTipos[tipoPlanActual]}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Opciones disponibles:',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: planesAlternativos.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay planes disponibles.',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : PageView.builder(
                            controller: PageController(viewportFraction: 0.85),
                            itemCount: planesAlternativos.length,
                            itemBuilder: (context, index) {
                              final plan = planesAlternativos[index];
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
                                              final precio =
                                                  obtenerPrecioDelPlan(
                                                    plan,
                                                  );

                                              final orderIdTec =
                                                  await AuthService.generarOrderID(
                                                    iccid: 'HJFDKJHSF98743978',
                                                    ofertaActualId:
                                                        plan['OfertaID']
                                                            .toString(),
                                                    ofertaNuevaId:
                                                        plan['OfertaID']
                                                            .toString(),
                                                    monto: precio.toString(),
                                                  );

                                              if (orderIdTec == null) return;

                                              final token =
                                                  await AuthService.obtenerTokenRecargas(
                                                    "h.martinez@tecomnet.mx",
                                                    "api-113f2717-c412-48d1-8da3-d3df93b2954c-29vpbp",
                                                  );

                                              if (token == null) return;

                                              final link =
                                                  await AuthService.obtenerLinkDePago(
                                                    token: token,
                                                    amount:
                                                        precio, 
                                                    description:
                                                        plan['Oferta'] ??
                                                        'Renovación del plan',
                                                    orderId: orderIdTec,
                                                  );

                                              if (link == null) return;

                                              if (context.mounted) {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (context) {
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
                                              backgroundColor: Colors.blue,
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
