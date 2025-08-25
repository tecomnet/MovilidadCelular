import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';

class SimRedirectScreen extends StatefulWidget {
  const SimRedirectScreen({super.key});

  @override
  State<SimRedirectScreen> createState() => _SimRedirectScreenState();
}

class _SimRedirectScreenState extends State<SimRedirectScreen> {
  @override
  void initState() {
    super.initState();
    verificarCantidadDeSIMs();
  }

  Future<void> verificarCantidadDeSIMs() async {
    final perfil = await AuthService.obtenerPerfil();
    if (perfil == null) {
      // Manejo si no hay perfil
      Navigator.pop(context);
      return;
    }

    final clienteId = perfil['ClienteId'];
    final sims = await AuthService.obtenerTablero(clienteId);

    if (sims != null && sims.length == 2) {
      Navigator.pushReplacementNamed(context, '/moreDataScreen');
    } else {
      Navigator.pushReplacementNamed(context, '/updatePlanScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
