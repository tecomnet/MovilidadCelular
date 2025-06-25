import 'package:flutter/material.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: ('Menú'),
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
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
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
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Hola Escandon Cruz Enrique',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDataCard(
              context,
              title: 'Más datos para tu BYD 1',
              mb: '500 MB',
              cost: '\$10.00 MXN',
              onPressed: () => Navigator.pushNamed(context, '/payment'),
            ),
            const SizedBox(height: 20),
            _buildDataCard(
              context,
              title: 'Más datos para tu BYD 2',
              mb: '1024 MB',
              cost: '\$2.00 MXN',
              onPressed: () => Navigator.pushNamed(context, '/payment'),
            ),
            const SizedBox(height: 20),
            _buildDataCard(
              context,
              title: 'Más datos para tu BYD 3',
              mb: '2048 MB',
              cost: '\$3.00 MXN',
              onPressed: () => Navigator.pushNamed(context, '/payment'),
            ),
            const SizedBox(height: 20),
            _buildDataCard(
              context,
              title: 'Más datos para tu BYD 4',
              mb: '3072 MB',
              cost: '\$4.00 MXN',
              onPressed: () => Navigator.pushNamed(context, '/payment'),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                '*Las tarifas publicadas incluyen el 16% de IVA\n*1 Gigabyte(GB) equivale a 1,024 Megabytes (MB)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 8),
              child: Center(
                child: Text(
                  '(c) 2025 por TECOMNET.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard(
    BuildContext context, {
    required String title,
    required String mb,
    required String cost,
    required VoidCallback onPressed,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 40,
            width: double.infinity,
            color: const Color.fromARGB(255, 29, 111, 75),
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  mb,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Costo: $cost',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Vigencia: Al corte de tu factura',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: onPressed,
              child: const Text(
                'Lo quiero',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
