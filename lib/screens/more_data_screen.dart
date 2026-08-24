import 'package:flutter/material.dart';
import 'package:movilidad_celulares/screens/menu_opciones_screen.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/screens/update_plan_screen.dart';
import 'package:movilidad_celulares/services/api_service.dart';

class MoreDataScreen extends StatefulWidget {
  const MoreDataScreen({super.key});

  @override
  State<MoreDataScreen> createState() => _MoreDataScreenState();
}

class _MoreDataScreenState extends State<MoreDataScreen> {
  bool cargando = true;
  List<Map<String, dynamic>> sims = [];

  @override
  void initState() {
    super.initState();
    cargarSims();
  }

  Future<void> cargarSims() async {
    setState(() => cargando = true);

    final perfil = await AuthService.obtenerPerfil();
    final tablero = await AuthService.obtenerTablero(perfil?['ClienteId'] ?? 0);

    setState(() {
      sims = tablero ?? [];
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Mostrar Datos',
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
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                itemCount: sims.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Card(
                      color: Colors.blue[700],
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: const Center(                          
                        ),
                      ),
                    );
                  } else if (index == 1) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'Elige una SIM',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else {
                    final sim = sims[index - 2];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${sim['Oferta']} - ${sim['MSISDN']}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                print("✅ ICCID enviado: ${sim['ICCID']}");
                                print("📦 SIM seleccionada: $sim");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MenuOpcionesScreen(
                                      iccidSeleccionado: sim['ICCID'],
                                      ofertaActualId: sim['OfertaID']
                                          .toString(),
                                      tipoPlan: sim['Tipo'],
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  52,
                                  159,
                                  246,
                                ),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                              ),
                              child: const Text('Seleccionar'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }
}
