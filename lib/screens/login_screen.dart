import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';
import 'package:movilidad_celulares/utils/permisos_utils.dart';
import 'package:movilidad_celulares/utils/session_manager.dart';
import 'package:movilidad_celulares/widgets/tecomnet_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String emailError = '';
  bool _passwordVisible = false;
  bool rememberUser = false;
  bool _cargando = false;

  bool esCorreoValido(String correo) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(correo);
  }

  @override
  void initState() {
    super.initState();
    SessionManager.getUser().then((savedUser) {
      if (savedUser != null && mounted) {
        setState(() {
          emailController.text = savedUser;
          rememberUser = true;
        });
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showNotice(context, 'Por favor ingresa correo y contraseña');
      return;
    }
    if (!esCorreoValido(email)) {
      showNotice(context, 'Ingresa un correo válido');
      return;
    }

    setState(() => _cargando = true);

    final tokenObtenido = await AuthService.obtenerToken(email, password);
    if (!mounted) return;
    if (!tokenObtenido) {
      setState(() => _cargando = false);
      showNotice(context, 'Usuario o contraseña incorrectos');
      return;
    }

    final perfil = await AuthService.obtenerPerfil(validandoLogin: true);
    if (!mounted) return;
    if (perfil == null) {
      setState(() => _cargando = false);
      showNotice(context, 'Usuario no existe o contraseña incorrecta');
      return;
    }
    AuthService.clienteId = perfil['ClienteId'];

    // pedirPermisos() devuelve la decisión real del usuario. No se bloquea el
    // acceso: los permisos son para el diagnóstico de red, no para la cuenta,
    // y el SDK trae PERMISSION_ALL_REQUIRED = false.
    final permisosConcedidos = await Permisos.pedirPermisos();
    if (!mounted) return;
    if (!permisosConcedidos) {
      showNotice(
        context,
        'Sin los permisos de diagnóstico no podremos medir tu red. '
        'Puedes concederlos más tarde desde Ajustes.',
        color: TecomnetTheme.aviso,
      );
    }

    await SessionManager.login(email, remember: rememberUser);
    if (!mounted) return;
    setState(() => _cargando = false);
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return TecomnetScreen(
      subtitulo: 'PORTAL DEL CLIENTE',
      ocupado: _cargando,
      mensajeOcupado: 'INICIANDO SESIÓN',
      children: [
        TecomnetField(
          etiqueta: 'CORREO',
          controller: emailController,
          icono: Icons.mail_outline_rounded,
          hint: 'correo@ejemplo.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          errorText: emailError,
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                emailError = 'Por favor ingresa tu correo';
              } else if (!esCorreoValido(value)) {
                emailError = 'Correo inválido';
              } else {
                emailError = '';
              }
            });
          },
        ),
        const SizedBox(height: 20),
        TecomnetField(
          etiqueta: 'CONTRASEÑA',
          controller: passwordController,
          icono: Icons.lock_outline_rounded,
          hint: '••••••••',
          obscure: !_passwordVisible,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _cargando ? null : _login(),
          sufijo: IconButton(
            icon: Icon(
              _passwordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: TecomnetTheme.textoTenue,
              size: 20,
            ),
            tooltip: _passwordVisible
                ? 'Ocultar contraseña'
                : 'Mostrar contraseña',
            onPressed: () =>
                setState(() => _passwordVisible = !_passwordVisible),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TecomnetLink(
            texto: '¿Olvidaste tu contraseña?',
            onTap: () => Navigator.pushNamed(context, '/recuperarPassword'),
          ),
        ),
        const SizedBox(height: 4),
        _recordarUsuario(),
        const SizedBox(height: 22),
        ActionButton(
          texto: 'INGRESAR',
          icono: Icons.login_rounded,
          // La rueda la lleva el velo de TecomnetScreen; aquí el botón solo
          // se deshabilita, para no ver dos indicadores girando a la vez.
          onPressed: _cargando ? null : _login,
        ),
      ],
    );
  }

  Widget _recordarUsuario() {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() => rememberUser = !rememberUser),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: rememberUser,
                onChanged: (v) => setState(() => rememberUser = v ?? false),
                activeColor: TecomnetTheme.azulClaro,
                checkColor: Colors.white,
                side: const BorderSide(
                  color: TecomnetTheme.bordeCampo,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Recordar usuario',
              style: TextStyle(
                color: TecomnetTheme.textoSecundario,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
