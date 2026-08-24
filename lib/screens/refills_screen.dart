import 'package:flutter/material.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/services/api_service.dart'; 

class RefillsScreen extends StatefulWidget {
  const RefillsScreen({super.key});

  @override
  State<RefillsScreen> createState() => _RefillsScreenState();
}

class _RefillsScreenState extends State<RefillsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _recargas = [];

  @override
void initState() {
  super.initState();
  cargarRecargasDinamico();
}

Future<void> cargarRecargasDinamico() async {
  setState(() => _isLoading = true);

  if (AuthService.token == null) {
    final loginExitoso = await AuthService.obtenerToken(AuthService.email ?? '', AuthService.password ?? '');
    if (!loginExitoso) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener token')),
      );
      return;
    }
  }

  final clienteId = AuthService.clienteId;
  if (clienteId == null) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se encontró cliente activo')),
    );
    return;
  }

  final recargas = await AuthService.obtenerRecargas(clienteId);
  if (recargas != null) {
    setState(() {
      _recargas = recargas;
      _isLoading = false;
    });
  } else {
    setState(() => _isLoading = false);
  }
}

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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _recargas.isEmpty
                ? const Center(
                    child: Text(
                      'Aun no hay recargas disponibles',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Card(
                        color: Colors.blue[700],
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: const SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Consulta tus recargas',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width - 40,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  columnSpacing: 20,
                                  headingRowColor: MaterialStateProperty.all(
                                      const Color(0xFFE0E0E0)),
                                  columns: const [
                                    DataColumn(label: Text('Oferta')),
                                    DataColumn(label: Text('MSISDN')),
                                    DataColumn(label: Text('Total')),
                                    DataColumn(label: Text('Fecha')),
                                    DataColumn(label: Text('Método de pago')),
                                  ],
                                  rows: _recargas
                                      .map(
                                        (recarga) => DataRow(
                                          cells: [
                                            DataCell(Text(recarga['Oferta'] ?? '')),
                                            DataCell(Text(recarga['MSISDN'] ?? '')),
                                            DataCell(Text(
                                                recarga['Total']?.toString() ?? '')),
                                            DataCell(Text(
                                                recarga['FechaRecarga']?.split('T')[0] ??
                                                    '')),
                                            DataCell(
                                                Text(recarga['NombreMetodo'] ?? '')),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          '(c) 2025 por TECOMNET.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
