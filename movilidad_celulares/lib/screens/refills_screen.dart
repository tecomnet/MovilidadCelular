import 'package:flutter/material.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';

class RefillsScreen extends StatelessWidget {
  const RefillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Consultar Recargas',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Center(
            ),
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
                        headingRowColor: MaterialStateProperty.all(const Color(0xFFE0E0E0)),
                        columns: const [
                          DataColumn(label: Text('Producto')),
                          DataColumn(label: Text('Auto')),
                          DataColumn(label: Text('Costo')),
                          DataColumn(label: Text('Fecha')),
                          DataColumn(label: Text('Método de pago')),
                        ],
                        rows: const [
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 2')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:48:24 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('ILIMITADO BYD TOTAL')),
                              DataCell(Text('ALL RAIN')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:52:38 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Mas MB para tu BYD 4')),
                              DataCell(Text('HAN MOTORS')),
                              DataCell(Text('\$10.00')),
                              DataCell(Text('2/6/2025 1:55:30 PM')),
                              DataCell(Text('Card')),
                            ],
                          ),
                        ],
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
