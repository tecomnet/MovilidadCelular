import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? perfil;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarPerfil();
  }

  void cargarPerfil() async {
    final datos = await AuthService.obtenerPerfil();

    setState(() {
      perfil = datos;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: '',
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : perfil == null
              ? const Center(child: Text('No se pudieron cargar los datos'))
              : _buildPerfilContent(),
    );
  }

  Widget _buildPerfilContent() {
    return Container(
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
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.blue[700],
                      margin: EdgeInsets.zero,
                      child: const SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Mis datos personales',
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
                      color: Colors.white,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            _buildReadOnlyField(
                              label: 'Nombre',
                              value: perfil?['Nombre'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'Apellido Paterno',
                              value: perfil?['ApellidoPaterno'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'Apellido Materno',
                              value: perfil?['ApellidoMaterno'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'Fecha Cumpleaños',
                              value: perfil?['FechaCumpleanios'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'CURP',
                              value: perfil?['CURP'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'Teléfono',
                              value: perfil?['Telefono'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'Email',
                              value: perfil?['Email'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'Estado',
                              value: perfil?['Estado'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'Colonia',
                              value: perfil?['Colonia'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'Dirección',
                              value: perfil?['Direccion'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'Código Postal',
                              value: perfil?['CP'] ?? '',
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.white,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            _buildReadOnlyField(
                              label: 'RFC',
                              value: perfil?['RFC'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'RFC Facturación',
                              value: perfil?['RFCFacturacion'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'Nombre Razon Social',
                              value: perfil?['NombreRazonSocial'] ?? '',
                            ),
                            _buildReadOnlyField(
                              label: 'Régimen Fiscal',
                              value: perfil?['RegimenFiscal'] ?? '',
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Para realizar cambios en su perfil, favor de enviar un correo a:\ncomercial@tecomnet.mx',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '(c) 2025 por TECOMNET.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  Widget _buildReadOnlyField(
      {required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start  ,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
