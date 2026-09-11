import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/widgets/panel_field.dart';
import 'package:movilidad_celulares/widgets/tecomnet_widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  static const String _ayudaNueva =
      'Mín. 8 caracteres, con mayúscula, minúscula, número y carácter especial.';

  final _actual = TextEditingController();
  final _nueva = TextEditingController();
  final _confirmar = TextEditingController();

  bool _verActual = false;
  bool _verNueva = false;
  bool _verConfirmar = false;
  bool _guardando = false;

  String _errorActual = '';
  String _errorNueva = '';
  String _errorConfirmar = '';

  @override
  void dispose() {
    _actual.dispose();
    _nueva.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  /// Devuelve el motivo por el que la contraseña no cumple, o cadena vacía.
  ///
  /// Las reglas son las que anuncia el texto de ayuda: si se promete algo bajo
  /// el campo, tiene que exigirse.
  String _motivoInvalida(String valor) {
    if (valor.isEmpty) return 'Ingresa la nueva contraseña';
    if (valor.length < 8) return 'Debe tener al menos 8 caracteres';
    if (!valor.contains(RegExp(r'[A-ZÁÉÍÓÚÑ]'))) {
      return 'Debe incluir al menos una mayúscula';
    }
    if (!valor.contains(RegExp(r'[a-záéíóúñ]'))) {
      return 'Debe incluir al menos una minúscula';
    }
    if (!valor.contains(RegExp(r'[0-9]'))) {
      return 'Debe incluir al menos un número';
    }
    if (!valor.contains(RegExp(r'[^A-Za-z0-9]'))) {
      return 'Debe incluir al menos un carácter especial';
    }
    return '';
  }

  bool _validar() {
    setState(() {
      _errorActual =
          _actual.text.isEmpty ? 'Ingresa tu contraseña actual' : '';
      _errorNueva = _motivoInvalida(_nueva.text);
      _errorConfirmar = _confirmar.text != _nueva.text
          ? 'No coincide con la nueva contraseña'
          : '';
    });
    return _errorActual.isEmpty &&
        _errorNueva.isEmpty &&
        _errorConfirmar.isEmpty;
  }

  Future<void> _cambiar() async {
    if (_guardando || !_validar()) return;

    setState(() => _guardando = true);

    final email = AuthService.email ?? '';
    final actual = _actual.text.trim();
    final nueva = _nueva.text.trim();

    // PENDIENTE (lógica): obtenerToken() ignora las credenciales que recibe, así
    // que esto no comprueba la contraseña actual; quien la valida es el backend
    // en cambiarPassword. Se conserva el flujo tal cual estaba.
    final tokenOk = await AuthService.obtenerToken(email, actual);
    if (!mounted) return;
    if (!tokenOk) {
      setState(() {
        _guardando = false;
        _errorActual = 'No pudimos verificar tu contraseña actual';
      });
      return;
    }

    final exito = await AuthService.cambiarPassword(
      passwordActual: actual,
      passwordNueva: nueva,
    );
    if (!mounted) return;

    if (!exito) {
      setState(() => _guardando = false);
      showNotice(
        context,
        'No se pudo cambiar la contraseña. Revisa los datos e intenta de nuevo.',
      );
      return;
    }

    final tokenNuevo = await AuthService.obtenerToken(email, nueva);
    if (!mounted) return;

    setState(() {
      _guardando = false;
      _actual.clear();
      _nueva.clear();
      _confirmar.clear();
      _errorActual = '';
      _errorNueva = '';
      _errorConfirmar = '';
    });

    showNotice(
      context,
      tokenNuevo
          ? 'Tu contraseña se cambió correctamente'
          : 'Contraseña cambiada, pero no se pudo renovar la sesión',
      color: tokenNuevo ? TecomnetTheme.verde : TecomnetTheme.aviso,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Cambiar contraseña',
      rutaActual: '/changePassword',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [_tarjeta()],
      ),
    );
  }

  Widget _tarjeta() {
    return Container(
      decoration: BoxDecoration(
        color: TecomnetTheme.panelTarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TecomnetTheme.panelBorde),
        boxShadow: [
          BoxShadow(
            color: TecomnetTheme.tintaFuerte.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.key_outlined,
                size: 21,
                color: TecomnetTheme.azulMarca,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Cambiar contraseña',
                  style: TextStyle(
                    color: TecomnetTheme.tintaFuerte,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          PanelField(
            etiqueta: 'Contraseña actual',
            controller: _actual,
            obscure: !_verActual,
            visible: _verActual,
            onAlternarVisibilidad: () =>
                setState(() => _verActual = !_verActual),
            errorText: _errorActual,
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              if (_errorActual.isNotEmpty) {
                setState(() => _errorActual = '');
              }
            },
          ),
          const SizedBox(height: 20),

          PanelField(
            etiqueta: 'Nueva contraseña',
            controller: _nueva,
            obscure: !_verNueva,
            visible: _verNueva,
            onAlternarVisibilidad: () => setState(() => _verNueva = !_verNueva),
            ayuda: _ayudaNueva,
            errorText: _errorNueva,
            textInputAction: TextInputAction.next,
            onChanged: (valor) {
              setState(() {
                // Solo se corrige el error ya mostrado; no se regaña mientras
                // el usuario todavía está escribiendo la contraseña.
                if (_errorNueva.isNotEmpty) {
                  _errorNueva = _motivoInvalida(valor);
                }
                if (_confirmar.text.isNotEmpty) {
                  _errorConfirmar = _confirmar.text != valor
                      ? 'No coincide con la nueva contraseña'
                      : '';
                }
              });
            },
          ),
          const SizedBox(height: 20),

          PanelField(
            etiqueta: 'Confirmar nueva contraseña',
            controller: _confirmar,
            obscure: !_verConfirmar,
            visible: _verConfirmar,
            onAlternarVisibilidad: () =>
                setState(() => _verConfirmar = !_verConfirmar),
            errorText: _errorConfirmar,
            textInputAction: TextInputAction.done,
            onChanged: (valor) {
              setState(() {
                _errorConfirmar = valor.isNotEmpty && valor != _nueva.text
                    ? 'No coincide con la nueva contraseña'
                    : '';
              });
            },
            onSubmitted: (_) => _cambiar(),
          ),
          const SizedBox(height: 26),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _guardando ? null : _cambiar,
              icon: _guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : const Icon(Icons.check_rounded, size: 20),
              label: Text(_guardando ? 'Guardando…' : 'Cambiar contraseña'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TecomnetTheme.azulProfundo,
                foregroundColor: Colors.white,
                disabledBackgroundColor: TecomnetTheme.azulProfundo
                    .withValues(alpha: 0.5),
                disabledForegroundColor: Colors.white70,
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
