import 'package:flutter/material.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Perfil',
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
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  margin: EdgeInsets.zero,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text(
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
                        _buildReadOnlyField(label: 'Género', value: 'Masculino'),
                        _buildReadOnlyField(label: 'Apellido paterno', value: 'Escandón'),
                        _buildReadOnlyField(label: 'Nombre', value: 'Enrique'),
                        _buildReadOnlyField(label: 'Nombre completo', value: 'Escandón Cruz Enrique'),
                        _buildReadOnlyField(label: 'Email', value: 'enrique@correo.com'),
                        _buildReadOnlyField(label: 'País', value: 'México'),
                        _buildReadOnlyField(label: 'Colonia', value: 'Centro'),
                        _buildReadOnlyField(label: 'Dirección', value: 'Calle tulipanes 123'),
                        _buildReadOnlyField(label: 'RFC', value: 'EDGTARY234'),
                        _buildReadOnlyField(label: 'Apellido materno', value: 'Cruz'),
                        _buildReadOnlyField(label: 'Fecha de nacimiento', value: '01/01/1990'),
                        _buildReadOnlyField(label: 'Teléfono', value: '555-123-4567'),
                        _buildReadOnlyField(label: 'Estado', value: 'CDMX'),
                        _buildReadOnlyField(label: 'Código postal', value: '01234'),
                        const SizedBox(height: 16),
                        const Text(
                          'Para realizar cambios en su perfil, favor de enviar un correo a:\ncomercial@tecomnet.mx',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
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
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
