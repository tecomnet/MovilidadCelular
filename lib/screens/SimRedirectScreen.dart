import 'package:flutter/material.dart';
import 'package:movilidad_celulares/screens/menu_opciones_screen.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/screens/update_plan_screen.dart';

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
} else if (sims != null && sims.length == 1) {
  final sim = sims[0];
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => MenuOpcionesScreen(
        iccidSeleccionado: sim['ICCID'],
        ofertaActualId: sim['OfertaID'].toString(),
        tipoPlan: sim['Tipo'],
      ),
    ),
  );
}

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
