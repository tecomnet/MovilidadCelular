import 'package:flutter/material.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';

class InformationpaymentScreen extends StatefulWidget {
  const InformationpaymentScreen({super.key});

  @override
  State<InformationpaymentScreen> createState() =>
      _InformationpaymentScreenState();
}

class _InformationpaymentScreenState extends State<InformationpaymentScreen> {
  String _formaPago = 'tarjeta';
  bool _requiereFactura = false;
  String _regimenFiscal = '605';

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Información de pago',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
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
                child: const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Información de pago',
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
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Por favor ingrese los datos solicitados, el pago se procesa a traves de un medio seguro.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Datos de facturación',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Nombre o Razón Social',
                        ),
                      ),
                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Régimen Fiscal',
                        ),
                        value: _regimenFiscal,
                        items: const [
                          DropdownMenuItem(
                            value: '605',
                            child: Text(
                              '605 - Sueldos y Salarios',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          DropdownMenuItem(
                            value: '612',
                            child: Text(
                              '612 - Personas físicas con actividades empresariales y profesionales',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          DropdownMenuItem(
                            value: '601',
                            child: Text(
                              '601 - General de ley personas morales',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _regimenFiscal = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 10),
                      const TextField(
                        decoration: InputDecoration(labelText: 'CP'),
                      ),
                      const SizedBox(height: 10),
                      const TextField(
                        decoration: InputDecoration(labelText: 'RFC'),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _requiereFactura,
                            onChanged: (value) {
                              setState(() {
                                _requiereFactura = value ?? false;
                              });
                            },
                          ),
                          const Text('Requiere Factura'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const TextField(
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 10),
                      const TextField(
                        decoration: InputDecoration(labelText: 'Teléfono'),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Forma de Pago',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListTile(
                        title: const Text('Tarjeta Crédito/Débito'),
                        leading: Radio<String>(
                          value: 'tarjeta',
                          groupValue: _formaPago,
                          onChanged: (value) {
                            setState(() {
                              _formaPago = value!;
                            });
                          },
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      ListTile(
                        title: const Text('Transferencia Bancaria'),
                        leading: Radio<String>(
                          value: 'transferencia',
                          groupValue: _formaPago,
                          onChanged: (value) {
                            setState(() {
                              _formaPago = value!;
                            });
                          },
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Paquete seleccionado',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text('Mas MB para tu BYD 1\n500 MB'),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Costo de paquete',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text('\$10.00'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Costo de plataforma',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text('\$0.35'),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text('\$10.35'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Continuar al pago',
                          ), 
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Text(
                  '(c) 2025 por TECOMNET.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
