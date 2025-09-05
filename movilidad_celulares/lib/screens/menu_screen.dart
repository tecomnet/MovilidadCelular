import 'package:flutter/material.dart';
import 'package:movilidad_celulares/utils/succes.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/widgets/payment_webview.dart';

class MenuScreen extends StatelessWidget {
  final String ofertaActualId;
  final String iccid;

  const MenuScreen({
    super.key,
    required this.ofertaActualId,
    required this.iccid,
  });

  @override
  Widget build(BuildContext context) {
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
        child: FutureBuilder<List<Map<String, dynamic>>?>(
          future: AuthService.obtenerOfertasPorTipo(2),
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
                  ofertaData: oferta,
                  ofertaId: ofertaActualId, // tu oferta actual
                  iccid: iccid, // tu ICCID
                  ofertaNuevaId: oferta['OfertaID']
                      .toString(), // la nueva oferta
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
    Map<String, dynamic>? ofertaData,
    required String ofertaId,
    required String iccid,
    required String ofertaNuevaId,
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
                const SizedBox(height: 16),
                if (ofertaData != null) ...[
                  Text('Descripción: ${ofertaData["Descripcion"] ?? "-"}'),
                  Text('Minutos: ${ofertaData["Minutos"] ?? "-"}'),
                  Text('SMS: ${ofertaData["Sms"] ?? "-"}'),
                  Text('Precio recarga: \$${(ofertaData["PrecioRecurrente"] as num).toStringAsFixed(2)} MXN',),
                  Text('Datos MB: ${ofertaData["DatosMB"] ?? "-"}'),
                  Text('Validez en días: ${ofertaData["ValidezDias"] ?? "-"}'),
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
              onPressed: () async {
                final precio = ofertaData?["PrecioRecurrente"];
                final descripcion = ofertaData?["Descripcion"] ?? "Recarga";

                if (precio == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Precio no válido")),
                  );
                  return;
                }

                final orderIdTec = await AuthService.generarOrderID(
                  iccid: iccid,
                  ofertaActualId: ofertaId,
                  ofertaNuevaId: ofertaNuevaId,
                  monto: precio.toString(),
                );

                if (orderIdTec == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error al generar OrderID")),
                  );
                  return;
                }

                final token = await AuthService.obtenerTokenRecargas(
                  "h.martinez@tecomnet.mx",
                  "api-113f2717-c412-48d1-8da3-d3df93b2954c-29vpbp",
                );

                if (token == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error al obtener token")),
                  );
                  return;
                }
                final urlExito = generarUrlExito();

                final link = await AuthService.obtenerLinkDePago(
                  token: token,
                  amount: (precio * 100).toInt(),
                  description: descripcion,
                  orderId: orderIdTec,
                  redirectUrl: urlExito,
                );
                // print('🔹 Token: $token');
                // print('🔹 OrderID: $orderIdTec');
                // print('🔹 URL de pago: $link');
                // print('🔹 URL de éxito: $urlExito');
                if (link == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Error al generar link de pago"),
                    ),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final screenSize = MediaQuery.of(context).size;
                    return Dialog(
                      insetPadding: const EdgeInsets.all(10),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SizedBox(
                        width: screenSize.width * 0.9,
                        height: screenSize.height * 0.8,
                        child: WebViewScreen(url: link),
                      ),
                    );
                  },
                );
              },
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
