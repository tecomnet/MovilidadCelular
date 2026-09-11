import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/widgets/tecomnet_widgets.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() =>
      _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool _isEnviando = false;
  String emailError = '';

  bool esCorreoValido(String correo) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(correo);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _enviarInstrucciones() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showNotice(context, 'Por favor ingresa tu correo');
      return;
    }
    if (!esCorreoValido(email)) {
      showNotice(context, 'Ingresa un correo válido');
      return;
    }

    setState(() => _isEnviando = true);

    // NOTA: esta llamada usa las credenciales de servicio y sobrescribe el
    // correo/contraseña guardados en AuthService. Es parte de los pendientes
    // de lógica, no del rediseño.
    await AuthService.obtenerToken(
      "Mobile.TECOMNET.USER_Admin",
      "VnhmJUD4ZW4564NHAyYD53FSH",
    );

    try {
      final resultado = await AuthService.recuperarContrasena(email);
      if (!mounted) return;
      setState(() => _isEnviando = false);

      if (resultado != null && resultado['mensaje'] != null) {
        showNotice(
          context,
          resultado['mensaje'].toString(),
          color: const Color(0xFF2E9E7B),
        );
        Navigator.pop(context);
      } else {
        showNotice(context, 'Ocurrió un error. Intenta de nuevo.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isEnviando = false);
      showNotice(context, 'Ocurrió un error. Intenta de nuevo.');
    } finally {
      // obtenerToken() guarda en AuthService las credenciales que recibe, y
      // arriba se le pasaron las de la cuenta de servicio. Se limpian pase lo
      // que pase, para que no queden ahí suplantando a las del cliente.
      AuthService.cerrarSesion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TecomnetScreen(
      subtitulo: 'RECUPERAR CONTRASEÑA',
      ocupado: _isEnviando,
      mensajeOcupado: 'ENVIANDO INSTRUCCIONES',
      pie: TecomnetLink(
        texto: '←  Volver a iniciar sesión',
        destacado: true,
        onTap: () => Navigator.pop(context),
      ),
      children: [
        const HelperText(
          'Escribe tu correo y te enviaremos instrucciones '
          'para restablecer tu contraseña.',
        ),
        const SizedBox(height: 26),
        TecomnetField(
          etiqueta: 'CORREO',
          controller: emailController,
          icono: Icons.mail_outline_rounded,
          hint: 'correo@ejemplo.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          errorText: emailError,
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                emailError = '';
              } else if (!esCorreoValido(value)) {
                emailError = 'Correo inválido';
              } else {
                emailError = '';
              }
            });
          },
          onSubmitted: (_) => _isEnviando ? null : _enviarInstrucciones(),
        ),
        const SizedBox(height: 24),
        ActionButton(
          texto: 'ENVIAR',
          icono: Icons.send_rounded,
          // La rueda la lleva el velo de TecomnetScreen; aquí el botón solo
          // se deshabilita, para no ver dos indicadores girando a la vez.
          onPressed: _isEnviando ? null : _enviarInstrucciones,
        ),
      ],
    );
  }
}
