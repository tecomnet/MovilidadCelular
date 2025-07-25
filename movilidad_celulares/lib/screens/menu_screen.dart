import 'package:flutter/material.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/services/api_service.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Menú',
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
        child: FutureBuilder<List<Map<String, dynamic>>?>(
          future: AuthService.obtenerOfertas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Center(
                child: Text(
                  "Error al cargar ofertas",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final ofertas = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: ofertas.length,
              itemBuilder: (context, index) {
                final oferta = ofertas[index];

                return _buildDataCard(
                  context,
                  title: oferta['Oferta'] ?? 'Sin título',
                  cost:
                      '\$${(oferta['PrecioRecurrente'] ?? 0).toStringAsFixed(2)} MXN',
                  onPressed: () => Navigator.pushNamed(context, '/payment'),
                  ofertaData: oferta,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDataCard(
    BuildContext context, {
    required String title,
    required String cost,
    required VoidCallback onPressed,
    Map<String, dynamic>? ofertaData, 
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Vigencia: Al corte de tu factura',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (ofertaData != null) ...[
                  Text('Descripción: ${ofertaData["Descripcion"] ?? "-"}'),
                  Text('Minutos: ${ofertaData["Minutos"] ?? "-"}'),
                  Text('SMS: ${ofertaData["Sms"] ?? "-"}'),
                  Text('Precio mensual: ${ofertaData["PrecioMensual"] ?? "-"}'),
                  Text('Precio anual: ${ofertaData["PrecioAnual"] ?? "-"}'),
                  Text('Precio recurrente: ${ofertaData["PrecioRecurrente"] ?? "-"}'),
                  Text('Datos MB: ${ofertaData["DatosMB"] ?? "-"}'),
                  Text(
                    'Es prepago: ${ofertaData["EsPrepago"] == true ? "Sí" : "No"}',
                  ),
                  Text('Validez en días: ${ofertaData["ValidezDias"] ?? "-"}'),
                  Text('Fecha alta: ${ofertaData["FechaAlta"] ?? "-"}'),
                  Text('Fecha baja: ${ofertaData["FechaBaja"] ?? ""}'),
                ],
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
