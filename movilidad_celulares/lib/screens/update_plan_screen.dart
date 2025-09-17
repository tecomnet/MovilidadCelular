import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/utils/succes.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/widgets/payment_webview.dart';

class UpdatePlanScreen extends StatefulWidget {
  final String iccidSeleccionado;
  final String ofertaActualId;
  final int tipoPlan;
  const UpdatePlanScreen({
    super.key,
    required this.iccidSeleccionado,
    required this.ofertaActualId,
    required this.tipoPlan,
  });

  @override
  State<UpdatePlanScreen> createState() => _UpdatePlanScreenState();
}

class _UpdatePlanScreenState extends State<UpdatePlanScreen> {
  String tipoPlanActual = 'prepago';
  bool cargando = true;
  List<Map<String, dynamic>> planesDisponibles = [];
  String iccid = '';
  String ofertaActualId = '';
  String msisdn= '';

  final Map<String, String> nombresTipos = {
    'prepago': 'Recarga',
    'pago_recurrente': 'Plan Mensual',
    'pago_anticipado': 'Plan Anual',
  };

  final Map<int, String> tipoNumeroATipo = {
    1: 'prepago',
    3: 'pago_recurrente',
    2: 'pago_anticipado',
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

    Map<String, dynamic>? planActual;

    if (tablero != null && tablero.isNotEmpty) {
      planActual = tablero.firstWhere(
        (p) => p['ICCID'] == widget.iccidSeleccionado,
        orElse: () => tablero[0],
      );

      tipoPlanActual = tipoNumeroATipo[planActual['Tipo']] ?? 'prepago';
      iccid = planActual['ICCID'] ?? '';
      ofertaActualId = planActual['OfertaID']?.toString() ?? '';
      msisdn = planActual['MSISDN'] ?? '';
    }
    

    List<Map<String, dynamic>> todasOfertas = [];

    final ofertas = await AuthService.obtenerOfertasPorTipo(widget.tipoPlan);
    if (ofertas != null) {
      todasOfertas.addAll(ofertas);
    }

    setState(() {
      planesDisponibles = todasOfertas;
      cargando = false;
    });
  }

  double obtenerPrecioDelPlan(Map<String, dynamic> plan) {
    switch (plan['Tipo']) {
      case 3:
        return plan['PrecioMensual'] ?? 0;
      case 1:
        return plan['PrecioRecurrente'] ?? 0;
      case 2:
        return plan['PrecioAnual'] ?? 0;
      default:
        return 0;
    }
  }

  List<Map<String, dynamic>> get planesFiltrados {
    return planesDisponibles
        .where((p) => p['Tipo'] == widget.tipoPlan)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: '',
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
                    child: planesFiltrados.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay planes disponibles.',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            itemCount: planesFiltrados.length,
                            itemBuilder: (context, index) {
                              final plan = planesFiltrados[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      12,
                                    ), 
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plan['Oferta'] ?? 'Plan sin nombre',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          plan['Descripcion'] ??
                                              'Sin descripción',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Precio: \$${obtenerPrecioDelPlan(plan).toStringAsFixed(2)} MXN',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              final precio =
                                                  obtenerPrecioDelPlan(plan);
                                              final orderIdTec =
                                                  await AuthService.generarOrderID(
                                                    iccid: iccid,
                                                    ofertaActualId:
                                                        ofertaActualId,
                                                    ofertaNuevaId:
                                                        plan['OfertaID']
                                                            .toString(),
                                                    monto: precio
                                                        .toStringAsFixed(2),
                                                        msisdn: msisdn,
                                                  );

                                              if (orderIdTec == null) return;

                                              final token =
                                                  await AuthService.obtenerTokenRecargas(
                                                    "h.martinez@tecomnet.mx",
                                                    "api-113f2717-c412-48d1-8da3-d3df93b2954c-29vpbp",
                                                  );

                                              if (token == null) return;
                                              final precioDouble =
                                                  obtenerPrecioDelPlan(plan);
                                              final precioInt =
                                                  (precioDouble * 100).toInt();
                                              final urlExito =
                                                  generarUrlExito();
                                              final link =
                                                  await AuthService.obtenerLinkDePago(
                                                    token: token,
                                                    amount: precioInt,
                                                    description:
                                                        plan['Oferta'] ??
                                                        'Renovación del plan',
                                                    orderId: orderIdTec,
                                                    redirectUrl: urlExito,
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
