import 'package:flutter/material.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/call_native_code.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String status = "Listo";

  Future<void> pedirPermisos() async {
    String result = await CallNativeCode.callNativePermission();
    setState(() {
      status = "Permisos: $result";
    });
  }

  Future<void> iniciarServicio() async {
    String result = await CallNativeCode.callNativeFunctionStarService("1000246915");
    setState(() {
      status = "Servicio iniciado: $result";
    });
  }

  Future<void> mostrarInterfaz() async {
    await CallNativeCode.showInterface("1000246915");
    setState(() {
      status = "Interfaz mostrada";
    });
  }
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: ('Home'),
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
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'BYD',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
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
            buildDataCard(
              context,
              title:
                  '2024 BYD HAN Negro HAN MOTORS - SADFSFSDF546546541 Mas MB para tu BYD 3',
              included: '2048 MB',
              additional: '0 MB',
              available: '2048 MB',
              validity: '30/06/2025',
              status: 'No Activo',
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
            ),
            const SizedBox(height: 20),
            buildDataCard(
              context,
              title:
                  '2000 YUAN PLUS Negro ALL RAIN - DSFSDFDS845464SDFSF Mas MB para tu BYD 3',
              included: '2048 MB',
              additional: '0 MB',
              available: '2048 MB',
              validity: '30/06/2025',
              status: 'No Activo',
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
            ),
            const SizedBox(height: 20),
            buildDataCard(
              context,
              title:
                  '2000 YUAN PLUS Negro ALL RAIN - DSFSDFDS845464SDFSF Mas MB para tu BYD 3',
              included: '2048 MB',
              additional: '0 MB',
              available: '2048 MB',
              validity: '30/06/2025',
              status: 'No Activo',
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
            ),
            const SizedBox(height: 20),
            buildDataCard(
              context,
              title:
                  '2000 YUAN PLUS Negro ALL RAIN - DSFSDFDS845464SDFSF Mas MB para tu BYD 3',
              included: '2048 MB',
              additional: '0 MB',
              available: '2048 MB',
              validity: '30/06/2025',
              status: 'No Activo',
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
            ),
            const SizedBox(height: 20),
            buildDataCard(
              context,
              title:
                  '2000 YUAN PLUS Negro ALL RAIN - DSFSDFDS845464SDFSF Mas MB para tu BYD 3',
              included: '2048 MB',
              additional: '0 MB',
              available: '2048 MB',
              validity: '30/06/2025',
              status: 'No Activo',
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
            ),
            const SizedBox(height: 20),
            buildDataCard(
              context,
              title:
                  '2000 YUAN PLUS Negro ALL RAIN - DSFSDFDS845464SDFSF Mas MB para tu BYD 3',
              included: '2048 MB',
              additional: '0 MB',
              available: '2048 MB',
              validity: '30/06/2025',
              status: 'No Activo',
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                '(c) 2025 por TECOMNET.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
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
    required VoidCallback onPressed,
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
            buildRichLine('Datos incluidos: ', included),
            buildRichLine('Datos adicionales: ', additional),
            buildRichLine('Datos disponibles: ', available),
            buildRichLine('Vigencia: ', validity),
            buildRichLine('Estatus de conectividad: ', status),
            const SizedBox(height: 16),
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
                'Quiero más datos',
                style: TextStyle(fontSize: 16, color: Colors.white),
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
