import 'package:flutter/material.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/call_native_code.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:movilidad_celulares/widgets/payment_webview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String status = "Listo";
  List<dynamic> _ofertas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarOfertas();
  }

  Future<void> cargarOfertas() async {
    final perfil = await AuthService.obtenerPerfil();
    if (perfil != null) {
      final clienteId = perfil['ClienteId'];
      final ofertas = await AuthService.obtenerTablero(clienteId);

      if (ofertas != null && ofertas.isNotEmpty) {
        final simActiva = ofertas.firstWhere(
          (sim) =>
              sim['Estatus'] == '1' &&
              sim['MSISDN'] != null &&
              sim['MSISDN'].toString().isNotEmpty,
          orElse: () => ofertas.first,
        );

        final msisdn = simActiva['MSISDN'];

        if (msisdn.isNotEmpty) {
          print("📲 Registrando dispositivo con MSISDN: $msisdn");
          await CallNativeCode.callNativeFunctionStartService(msisdn);
        } else {
          print("⚠️ MSISDN vacío, no se registró en el SDK");
        }

        setState(() {
          _ofertas = ofertas;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> pedirPermisos() async {
    String result = await CallNativeCode.callNativePermission();
    setState(() {
      status = "Permisos: $result";
    });
  }

  Future<void> iniciarServicio() async {
    String result = await CallNativeCode.callNativeFunctionStartService("");
    setState(() {
      status = "Servicio iniciado: $result";
    });
  }

  Future<void> mostrarInterfaz() async {
    await CallNativeCode.showInterface("");
    setState(() {
      status = "Interfaz mostrada";
    });
  }

  Future<bool> _onWillPop() async {
    bool? exitApp = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Estas saliendo de Movilidad Tecomnet'),
        content: const Text('¿Estas seguro que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sí'),
          ),
        ],
      ),
    );
    return exitApp ?? false;
  }

  Widget buildDataUsageIndicator(
    String usedStr,
    String availableStr,
    String FechaVencimiento,
  ) {
    double usedMB = double.tryParse(usedStr.replaceAll(' MB', '')) ?? 0;
    double availableMB =
        double.tryParse(availableStr.replaceAll(' MB', '')) ?? 0;
    double totalMB = usedMB + availableMB;
    double percent = (totalMB > 0) ? usedMB / totalMB : 0;

    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Consumo de Internet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF0078D7),
          ),
        ),
        const SizedBox(height: 10),
        CircularPercentIndicator(
          radius: 80.0,
          lineWidth: 14.0,
          animation: true,
          percent: percent.clamp(0.0, 1.0),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.language, color: Color(0xFF0078D7), size: 26),
              const SizedBox(height: 4),
              const Text(
                'Ha consumido',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                "${(usedMB / 1024).toStringAsFixed(2)} GB",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0078D7),
                ),
              ),
              Text(
                "de ${(totalMB / 1024).toStringAsFixed(2)} GB",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: const Color(0xFF0078D7),
          backgroundColor: Colors.grey.shade200,
        ),
        const SizedBox(height: 6),
        Text(
          'Vigencia: $FechaVencimiento',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '${(percent * 100).toStringAsFixed(0)}% \nConsumido',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${(availableMB / 1024).toStringAsFixed(2)} GB\nDisponible',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BaseScaffold(
        title: 'Home',
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 600, // ancho máximo para tablets y pantallas grandes
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Card(
                                      color: Colors.blue[700],
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Text(
                                            'Hola Escandon Cruz Enrique',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ..._ofertas.map((oferta) {
                                      final String ofertaNombre = oferta['Oferta'] ?? '';
                                      final double precio = double.tryParse(
                                            RegExp(r'\d+').firstMatch(ofertaNombre)?.group(0) ?? '',
                                          ) ??
                                          0.0;

                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: buildDataCard(
                                          context,
                                          title: '$ofertaNombre - ${oferta['Descripcion']}',
                                          included: '${oferta['MBAsignados']} MB',
                                          additional: '${oferta['MBAdicionales']} MB',
                                          available: '${oferta['MBDisponibles']} MB',
                                          used: '${oferta['MBUsados']} MB',
                                          minutes: '${oferta['Minutos']}',
                                          sms: '${oferta['Sms']}',
                                          validity: oferta['FechaVencimiento']?.split('T').first ?? '',
                                          status: oferta['Estatus'] == '1' ? 'Activo' : 'No Activo',
                                          prepaid: (oferta['EsPrepago'] == true) ? 'Prepago' : 'Pospago',
                                          precio: precio,
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/menu');
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          color: Colors.transparent,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '(c) 2025 por TECOMNET.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget buildDataCard(
    BuildContext context, {
    required String title,
    required String included,
    required String additional,
    required String available,
    required String validity,
    required String status,
    required String used,
    required String minutes,
    required String sms,
    required String prepaid,
    required VoidCallback onPressed,
    required double precio,
  }) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 74, 177, 229),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            buildDataUsageIndicator(used, available, validity),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () async {
                      final token = await LklService.obtenerTokenRecargas(
                        "h.martinez@tecomnet.mx",
                        "api-113f2717-c412-48d1-8da3-d3df93b2954c-29vpbp",
                      );

                      if (token != null) {
                        final link = await LklService.obtenerLinkDePago(
                          token: token,
                          amount: (precio * 100).toInt(),
                          description: 'Renovación del plan',
                        );

                        if (link != null) {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                insetPadding: const EdgeInsets.all(10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  height: MediaQuery.of(context).size.height * 0.8,
                                  child: WebViewScreen(url: link),
                                ),
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error al generar link de pago'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error al obtener token')),
                        );
                      }
                    },
                    child: const Text(
                      'Renovar Plan',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: onPressed,
                    child: const Text(
                      'Recargar Saldo',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRichLine(String label, String value) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(color: Colors.green, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
