import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';
import 'package:movilidad_celulares/utils/pantalla_segura.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/widgets/panel_field.dart';
import 'package:movilidad_celulares/widgets/tecomnet_widgets.dart';

/// Formulario para guardar una tarjeta en el procesador de pagos.
///
/// Maneja el número completo y el CVV, así que:
///   * no traza nada (tampoco lo hace AuthService.tokenizarTarjeta),
///   * el teclado va sin sugerencias ni autocorrección en esos campos,
///   * los campos de la tarjeta se vacían al guardar y al salir,
///   * la pantalla no se puede capturar ni sale en apps recientes.
class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _numero = TextEditingController();
  final _titular = TextEditingController();
  final _vencimiento = TextEditingController();
  final _cvv = TextEditingController();
  final _correo = TextEditingController();
  final _telefono = TextEditingController();

  bool _guardando = false;

  String _errorNumero = '';
  String _errorTitular = '';
  String _errorVencimiento = '';
  String _errorCvv = '';
  String _errorCorreo = '';
  String _errorTelefono = '';

  @override
  void initState() {
    super.initState();
    // Mientras esta pantalla esté abierta no se puede capturar ni aparece en la
    // vista de apps recientes: ahí se ve el número de la tarjeta.
    PantallaSegura.activar();
    _precargarContacto();
  }

  @override
  void dispose() {
    // Se vacían antes de liberar: que el número y el CVV no sigan en memoria
    // más de lo necesario.
    for (final c in [
      _numero,
      _titular,
      _vencimiento,
      _cvv,
      _correo,
      _telefono,
    ]) {
      c.clear();
      c.dispose();
    }
    PantallaSegura.desactivar();
    super.dispose();
  }

  /// Rellena correo y teléfono con los del perfil, para no pedirlos otra vez.
  /// Solo si el cliente todavía no escribió nada en ellos.
  Future<void> _precargarContacto() async {
    final perfil = await AuthService.obtenerPerfil();
    if (!mounted || perfil == null) return;
    setState(() {
      if (_correo.text.isEmpty) {
        _correo.text = (perfil['Email'] ?? '').toString().trim();
      }
      if (_telefono.text.isEmpty) {
        _telefono.text = (perfil['Telefono'] ?? '').toString().trim();
      }
    });
  }

  // ---------------------------------------------------------------- validación

  String get _soloDigitosNumero => _numero.text.replaceAll(RegExp(r'\D'), '');

  /// SinergyPay solo acepta tarjetas de 16 dígitos (Visa y Mastercard). Por
  /// eso tampoco se contempla American Express, que tiene 15 y CVV de 4.
  static const int _digitosTarjeta = 16;

  /// Algoritmo de Luhn: descarta números mal tecleados antes de mandarlos.
  static bool _pasaLuhn(String digitos) {
    var suma = 0;
    var duplicar = false;
    for (var i = digitos.length - 1; i >= 0; i--) {
      var d = int.parse(digitos[i]);
      if (duplicar) {
        d *= 2;
        if (d > 9) d -= 9;
      }
      suma += d;
      duplicar = !duplicar;
    }
    return suma % 10 == 0;
  }

  String _motivoNumero() {
    final n = _soloDigitosNumero;
    if (n.isEmpty) return 'Ingresa el número de la tarjeta';
    if (n.length != _digitosTarjeta) {
      return 'Debe tener $_digitosTarjeta dígitos';
    }
    if (!_pasaLuhn(n)) return 'El número de tarjeta no es válido';
    return '';
  }

  String _motivoTitular() {
    final t = _titular.text.trim();
    if (t.isEmpty) return 'Ingresa el nombre como aparece en la tarjeta';
    if (t.length < 3) return 'Escribe el nombre completo';
    return '';
  }

  /// Mes y año de «MM/AA», o null si no es una fecha válida.
  (int, int)? get _mesAnio {
    final m = RegExp(r'^(\d{2})/(\d{2})$').firstMatch(_vencimiento.text);
    if (m == null) return null;
    final mes = int.parse(m.group(1)!);
    final anio = 2000 + int.parse(m.group(2)!);
    if (mes < 1 || mes > 12) return null;
    return (mes, anio);
  }

  String _motivoVencimiento() {
    if (_vencimiento.text.isEmpty) return 'Ingresa la fecha de vencimiento';
    final fecha = _mesAnio;
    if (fecha == null) return 'Usa el formato MM/AA';
    final (mes, anio) = fecha;
    final hoy = DateTime.now();
    // Una tarjeta vale hasta el último día de su mes de vencimiento.
    if (anio < hoy.year || (anio == hoy.year && mes < hoy.month)) {
      return 'La tarjeta está vencida';
    }
    return '';
  }

  String _motivoCvv() {
    if (_cvv.text.isEmpty) return 'Ingresa el código de seguridad';
    if (_cvv.text.length != 3) return 'Debe tener 3 dígitos';
    return '';
  }

  String _motivoCorreo() {
    final c = _correo.text.trim();
    if (c.isEmpty) return 'Ingresa tu correo';
    if (!RegExp(r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(c)) {
      return 'Correo inválido';
    }
    return '';
  }

  String _motivoTelefono() {
    final t = _telefono.text.replaceAll(RegExp(r'\D'), '');
    if (t.isEmpty) return 'Ingresa tu teléfono';
    if (t.length != 10) return 'Debe tener 10 dígitos';
    return '';
  }

  bool _validar() {
    setState(() {
      _errorNumero = _motivoNumero();
      _errorTitular = _motivoTitular();
      _errorVencimiento = _motivoVencimiento();
      _errorCvv = _motivoCvv();
      _errorCorreo = _motivoCorreo();
      _errorTelefono = _motivoTelefono();
    });
    return [
      _errorNumero,
      _errorTitular,
      _errorVencimiento,
      _errorCvv,
      _errorCorreo,
      _errorTelefono,
    ].every((e) => e.isEmpty);
  }

  // ------------------------------------------------------------------ guardado

  Future<void> _guardar() async {
    if (_guardando || !_validar()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _guardando = true);

    // Sin ClienteID la tarjeta se guardaría en la pasarela pero no en el
    // catálogo del cliente, y nunca la vería en «Mis tarjetas».
    final clienteId = await AuthService.clienteIdActual();
    if (!mounted) return;
    if (clienteId == null) {
      setState(() => _guardando = false);
      showNotice(
        context,
        'No pudimos identificar tu cuenta. Vuelve a iniciar sesión.',
      );
      return;
    }

    final (mes, anio) = _mesAnio!;
    final resultado = await AuthService.tokenizarTarjeta(
      clienteId: clienteId,
      numero: _soloDigitosNumero,
      titular: _titular.text.trim(),
      cvv: _cvv.text,
      mesVencimiento: mes,
      anioVencimiento: anio,
      correo: _correo.text.trim(),
      telefono: _telefono.text.replaceAll(RegExp(r'\D'), ''),
    );
    if (!mounted) return;
    setState(() => _guardando = false);

    if (resultado == null) {
      showNotice(
        context,
        'No se pudo conectar. Revisa tu conexión e intenta de nuevo.',
      );
      return;
    }

    if (!resultado.ok) {
      showNotice(
        context,
        resultado.mensaje ??
            'No se pudo agregar la tarjeta. Revisa los datos e intenta de nuevo.',
      );
      return;
    }

    _numero.clear();
    _titular.clear();
    _vencimiento.clear();
    _cvv.clear();

    // Si ya estaba, el servidor conservó la original: no es un error, pero
    // tampoco se agregó nada, y decir «agregada» haría pensar que ahora hay dos.
    showNotice(
      context,
      resultado.yaEstaba
          ? 'Esa tarjeta ya estaba guardada en tu cuenta'
          : 'Tarjeta agregada correctamente',
      color: resultado.yaEstaba ? TecomnetTheme.azulMarca : TecomnetTheme.verde,
    );

    // Se vuelve a «Mis tarjetas», que es desde donde se llega aquí, avisándole
    // que recargue la lista. El aviso sobrevive a la navegación porque cuelga
    // del ScaffoldMessenger de la app, no de esta pantalla.
    Navigator.of(context).pop(true);
  }

  // --------------------------------------------------------------------- vista

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Agregar tarjeta',
      rutaActual: '/addCard',
      body: AbsorbPointer(
        absorbing: _guardando,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [_tarjeta()],
        ),
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
          const Row(
            children: [
              Icon(
                Icons.credit_card_rounded,
                size: 21,
                color: TecomnetTheme.azulMarca,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Agregar tarjeta',
                  style: TextStyle(
                    color: TecomnetTheme.tintaFuerte,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Guarda una tarjeta de crédito o débito para tus pagos.',
            style: TextStyle(
              color: TecomnetTheme.tintaMedia,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),

          PanelField(
            etiqueta: 'Número de tarjeta',
            controller: _numero,
            hint: '0000 0000 0000 0000',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            enableSuggestions: false,
            autocorrect: false,
            inputFormatters: [_GruposDeCuatro()],
            errorText: _errorNumero,
            onChanged: (_) {
              if (_errorNumero.isNotEmpty) setState(() => _errorNumero = '');
            },
          ),
          const SizedBox(height: 20),

          PanelField(
            etiqueta: 'Nombre del titular',
            controller: _titular,
            hint: 'Como aparece en la tarjeta',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            enableSuggestions: false,
            autocorrect: false,
            errorText: _errorTitular,
            onChanged: (_) {
              if (_errorTitular.isNotEmpty) setState(() => _errorTitular = '');
            },
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PanelField(
                  etiqueta: 'Vencimiento',
                  controller: _vencimiento,
                  hint: 'MM/AA',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  enableSuggestions: false,
                  autocorrect: false,
                  inputFormatters: [_MesAnio()],
                  errorText: _errorVencimiento,
                  onChanged: (_) {
                    if (_errorVencimiento.isNotEmpty) {
                      setState(() => _errorVencimiento = '');
                    }
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: PanelField(
                  etiqueta: 'CVV',
                  controller: _cvv,
                  hint: '000',
                  obscure: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  enableSuggestions: false,
                  autocorrect: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  errorText: _errorCvv,
                  onChanged: (_) {
                    if (_errorCvv.isNotEmpty) setState(() => _errorCvv = '');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          PanelField(
            etiqueta: 'Correo electrónico',
            controller: _correo,
            hint: 'correo@ejemplo.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            errorText: _errorCorreo,
            onChanged: (_) {
              if (_errorCorreo.isNotEmpty) setState(() => _errorCorreo = '');
            },
          ),
          const SizedBox(height: 20),

          PanelField(
            etiqueta: 'Teléfono',
            controller: _telefono,
            hint: '10 dígitos',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            errorText: _errorTelefono,
            onChanged: (_) {
              if (_errorTelefono.isNotEmpty) {
                setState(() => _errorTelefono = '');
              }
            },
            onSubmitted: (_) => _guardar(),
          ),
          const SizedBox(height: 26),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: _guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : const Icon(Icons.add_card_rounded, size: 20),
              label: Text(_guardando ? 'Guardando…' : 'Agregar tarjeta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TecomnetTheme.azulProfundo,
                foregroundColor: Colors.white,
                disabledBackgroundColor: TecomnetTheme.azulProfundo.withValues(
                  alpha: 0.5,
                ),
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
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 15,
                color: TecomnetTheme.tintaSuave,
              ),
              SizedBox(width: 6),
              Text(
                'Conexión segura',
                style: TextStyle(color: TecomnetTheme.tintaSuave, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// «4000000000002701» → «4000 0000 0000 2701» mientras se escribe, con un
/// máximo de 16 dígitos.
///
/// El límite se cuenta aquí, sobre los dígitos, y no con
/// LengthLimitingTextInputFormatter: ese cuenta caracteres, espacios incluidos,
/// y con el número ya formateado rechazaba entero un número pegado en vez de
/// recortarlo.
class _GruposDeCuatro extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue anterior,
    TextEditingValue nuevo,
  ) {
    var digitos = nuevo.text.replaceAll(RegExp(r'\D'), '');
    if (digitos.length > 16) digitos = digitos.substring(0, 16);
    final buffer = StringBuffer();
    for (var i = 0; i < digitos.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digitos[i]);
    }
    final texto = buffer.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

/// «1228» → «12/28» mientras se escribe, con un máximo de 4 dígitos. El
/// límite va aquí por la misma razón que en _GruposDeCuatro.
class _MesAnio extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue anterior,
    TextEditingValue nuevo,
  ) {
    var digitos = nuevo.text.replaceAll(RegExp(r'\D'), '');
    if (digitos.length > 4) digitos = digitos.substring(0, 4);
    final texto = digitos.length > 2
        ? '${digitos.substring(0, 2)}/${digitos.substring(2)}'
        : digitos;
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}
