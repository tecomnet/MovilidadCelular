import 'package:flutter/material.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/services/api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _actualController = TextEditingController();
  final _nuevaController = TextEditingController();
  final _confirmarController = TextEditingController();
  bool _loading = false;

  bool _verActual = false;
  bool _verNueva = false;
  bool _verConfirmar = false;

  Future<void> _cambiarPassword() async {
    print('Actual: ${_actualController.text}');
    print('Nueva: ${_nuevaController.text}');
    print('Confirmar: ${_confirmarController.text}');
    final email = AuthService.email;
    final passwordActual = _actualController.text.trim();
    final passwordNueva = _nuevaController.text.trim();
    final passwordConfirmar = _confirmarController.text.trim();

    final tokenOk = await AuthService.obtenerToken(email!, passwordActual);
    if (!tokenOk) {
      print('❌ No se pudo obtener token con la contraseña actual');
      return;
    }

    final exito = await AuthService.cambiarPassword(
      passwordActual: passwordActual,
      passwordNueva: passwordNueva,
    );

    if (exito) {
      final tokenNuevo = await AuthService.obtenerToken(email, passwordNueva);
      if (tokenNuevo) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Se cambio la contraseña correctamente'),
          ),
        );
        _actualController.clear();
        _nuevaController.clear();
        _confirmarController.clear();
      } else {
        print('⚠️ Contraseña cambiada, pero no se pudo obtener token nuevo');
      }
    } else {
      print('❌ Error al cambiar contraseña');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Cambiar Contraseña',
      body: Container(
        height: double.infinity,
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Card(
                  color: Colors.blue[700],
                  margin: EdgeInsets.zero,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Cambio de contraseña',
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
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cambiar contraseña',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text(
                          'Contraseña actual',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        _buildPasswordField(
                          _actualController,
                          ocultar: !_verActual,
                          onVerPressed: () {
                            setState(() => _verActual = !_verActual);
                          },
                        ),

                        const SizedBox(height: 16),
                        const Text(
                          'Nueva contraseña',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        _buildPasswordField(
                          _nuevaController,
                          ocultar: !_verNueva,
                          onVerPressed: () {
                            setState(() => _verNueva = !_verNueva);
                          },
                        ),

                        const SizedBox(height: 16),
                        const Text(
                          'Confirmar nueva contraseña',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        _buildPasswordField(
                          _confirmarController,
                          ocultar: !_verConfirmar,
                          onVerPressed: () {
                            setState(() => _verConfirmar = !_verConfirmar);
                          },
                        ),

                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: _loading ? null : _cambiarPassword,
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
                            child: _loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Cambiar contraseña',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
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
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller, {
    required bool ocultar,
    required VoidCallback onVerPressed,
  }) {
    return TextField(
      controller: controller,
      obscureText: ocultar,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            ocultar ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onVerPressed,
        ),
      ),
    );
  }
}
