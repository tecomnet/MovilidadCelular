import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movilidad_celulares/services/api_service.dart';
// import 'package:movilidad_celulares/utils/encryption_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class Permisos {
  static const MethodChannel _channel = MethodChannel('channelUpdateKPI');

  static Future<bool> pedirPermisos() async {
    try {
      final result = await _channel.invokeMethod('validarPermisos');
      return result == 'Ok';
    } on PlatformException catch (e) {
      print("Error al pedir permisos: ${e.message}");
      return false;
    }
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String mensaje = '';

  bool rememberUser = false;

bool esCorreoValido(String correo) {
  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(correo);
}

void _login() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Por favor ingresa correo y contraseña'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }
  if (!esCorreoValido(email)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ingresa un correo válido'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final tokenObtenido = await AuthService.obtenerToken(email, password);

  if (!tokenObtenido) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuario o contraseña incorrectos'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final perfil = await AuthService.obtenerPerfil();

  if (perfil == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuario no existe o contraseña incorrecta'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  Navigator.pushNamed(context, '/home');
}




// void _validarLogin() {
//   final correo = emailController.text.trim();
//   final password = passwordController.text;
//   // final correoCifrada = EncryptionHelper.encryptCorreo(correo);
//   // print('🔒 Correo cifrado: $correoCifrada');
//   // final passwordCifrada = EncryptionHelper.encryptPassword(password);
//   // print('🔒 Contraseña cifrada: $passwordCifrada');

//   if (correo == usuarioValido && password == contrasenaValida) {
//     Navigator.pushNamed(context, '/home');
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('❌ Usuario o contraseña incorrectos'),
//         backgroundColor: Colors.red,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF003366),
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/Imagenes/Logo.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Buenas tardes',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'Correo electrónico',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'name@example.com',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Contraseña',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: rememberUser,
                            onChanged: (bool? value) {
                              setState(() {
                                rememberUser = value ?? false;
                              });
                            },
                          ),
                          const Text('Recordar usuario'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          bool permisosConcedidos =
                              await Permisos.pedirPermisos();
                          if (permisosConcedidos) {
                            _login();
                            // _validarLogin();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'No se concedieron todos los permisos necesarios.',
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003366),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Iniciar Sesión'),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Regístrate aquí',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
