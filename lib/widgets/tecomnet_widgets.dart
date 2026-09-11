import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';
import 'package:movilidad_celulares/widgets/constellation_background.dart';

/// Piezas compartidas del Portal del Cliente.
///
/// Todas las pantallas de acceso (login, recuperar contraseña, cambio de
/// contraseña…) son la misma tarjeta sobre el fondo de constelación, cambiando
/// solo el subtítulo y el contenido. Vive aquí para no repetir el armazón.

/// Armazón de pantalla: fondo animado + tarjeta centrada con el logo.
class TecomnetScreen extends StatefulWidget {
  /// Texto bajo el logo: PORTAL DEL CLIENTE, RECUPERAR CONTRASEÑA…
  final String subtitulo;

  /// Contenido de la tarjeta, bajo el subtítulo.
  final List<Widget> children;

  /// Enlace opcional al pie, fuera de la tarjeta no: va dentro, al final.
  final Widget? pie;

  /// Mientras hay una operación en curso se bloquea la pantalla entera.
  ///
  /// Sin esto el usuario puede seguir escribiendo o navegar a otra pantalla
  /// con la petición a medias, y volver a una sesión a medio construir.
  final bool ocupado;

  /// Texto bajo el indicador mientras `ocupado`. Sin él solo se ve la rueda.
  final String? mensajeOcupado;

  const TecomnetScreen({
    super.key,
    required this.subtitulo,
    required this.children,
    this.pie,
    this.ocupado = false,
    this.mensajeOcupado,
  });

  @override
  State<TecomnetScreen> createState() => _TecomnetScreenState();
}

class _TecomnetScreenState extends State<TecomnetScreen> {
  @override
  void didUpdateWidget(TecomnetScreen anterior) {
    super.didUpdateWidget(anterior);

    // Al empezar a cargar hay que soltar el foco. AbsorbPointer solo detiene el
    // dedo: si un campo se quedó enfocado, el teclado sigue arriba y el usuario
    // sigue escribiendo mientras la petición está en vuelo.
    if (widget.ocupado && !anterior.ocupado) {
      // Fuera del fotograma en curso: quitar el foco marca widgets como sucios
      // y hacerlo durante build lanza excepción.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.ocupado) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TecomnetTheme.fondoAlto,
      body: PopScope(
        // El botón atrás también se bloquea: salir con la petición a medias
        // deja la sesión a medio construir.
        canPop: !widget.ocupado,
        child: Stack(
          children: [
            AbsorbPointer(
              // El bloqueo envuelve al fondo, no solo a la tarjeta: si no, la
              // constelación sigue tejiendo líneas bajo el dedo y la pantalla
              // parece viva aunque ya no acepte nada.
              absorbing: widget.ocupado,
              child: ConstellationBackground(
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 28,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Container(
                          decoration: BoxDecoration(
                            color: TecomnetTheme.tarjeta.withValues(
                              alpha: 0.88,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: TecomnetTheme.bordeTarjeta,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.45),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const TecomnetLogo(),
                              const SizedBox(height: 10),
                              Text(
                                widget.subtitulo,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: TecomnetTheme.textoSecundario,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 3.4,
                                ),
                              ),
                              const SizedBox(height: 28),
                              ...widget.children,
                              if (widget.pie != null) ...[
                                const SizedBox(height: 20),
                                widget.pie!,
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // El velo va fuera del AbsorbPointer para que el difuminado cubra
            // también el fondo animado, no solo la tarjeta.
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: widget.ocupado
                      ? _VeloDeCarga(mensaje: widget.mensajeOcupado)
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Capa de espera: difumina la pantalla y deja el indicador en el centro.
///
/// La rueda del botón mide 22 px y queda abajo del todo; con una petición que
/// puede tardar varios segundos se lee como «puedes seguir» en vez de como
/// «espera». En el centro y sobre la pantalla completa no hay ambigüedad.
class _VeloDeCarga extends StatelessWidget {
  final String? mensaje;

  const _VeloDeCarga({this.mensaje});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: ColoredBox(
        color: TecomnetTheme.fondoAlto.withValues(alpha: 0.72),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 32),
            decoration: BoxDecoration(
              color: TecomnetTheme.tarjeta.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: TecomnetTheme.bordeTarjeta),
              boxShadow: [
                BoxShadow(
                  color: TecomnetTheme.cian.withValues(alpha: 0.16),
                  blurRadius: 46,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 46,
                  height: 46,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    color: TecomnetTheme.cian,
                  ),
                ),
                if (mensaje != null) ...[
                  const SizedBox(height: 22),
                  Text(
                    mensaje!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: TecomnetTheme.textoSecundario,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo con el halo cian detrás.
class TecomnetLogo extends StatelessWidget {
  final double alto;

  const TecomnetLogo({super.key, this.alto = 104});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: TecomnetTheme.cian.withValues(alpha: 0.22),
              blurRadius: 44,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Image.asset(
          'assets/Imagenes/Logo.png',
          height: alto,
          fit: BoxFit.contain,
          // Si el asset faltara, la pantalla sigue siendo usable.
          errorBuilder: (_, __, ___) => const SizedBox(height: 8),
        ),
      ),
    );
  }
}

/// Párrafo explicativo centrado, como el de recuperar contraseña.
class HelperText extends StatelessWidget {
  final String texto;

  const HelperText(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: TecomnetTheme.textoSecundario,
        fontSize: 14.5,
        height: 1.5,
      ),
    );
  }
}

/// Campo con etiqueta en mayúsculas encima y el chip del icono a la izquierda.
class TecomnetField extends StatelessWidget {
  final String etiqueta;
  final TextEditingController controller;
  final IconData icono;
  final String hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscure;
  final Widget? sufijo;
  final String errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const TecomnetField({
    super.key,
    required this.etiqueta,
    required this.controller,
    required this.icono,
    required this.hint,
    this.keyboardType,
    this.textInputAction,
    this.obscure = false,
    this.sufijo,
    this.errorText = '',
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final tieneError = errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: TecomnetTheme.etiquetaCampo),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: TecomnetTheme.campo,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: tieneError
                  ? TecomnetTheme.error.withValues(alpha: 0.7)
                  : TecomnetTheme.bordeCampo,
            ),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TecomnetTheme.chipIcono,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icono, size: 18, color: TecomnetTheme.cian),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: const TextStyle(
                    color: TecomnetTheme.textoPrincipal,
                    fontSize: 15.5,
                  ),
                  cursorColor: TecomnetTheme.cian,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: TecomnetTheme.textoTenue,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              if (sufijo != null) sufijo! else const SizedBox(width: 8),
            ],
          ),
        ),
        if (tieneError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(
                color: TecomnetTheme.error,
                fontSize: 12.5,
              ),
            ),
          ),
      ],
    );
  }
}

/// Botón principal con degradado, halo e indicador de carga.
class ActionButton extends StatelessWidget {
  final String texto;
  final IconData icono;
  final VoidCallback? onPressed;
  final bool cargando;

  const ActionButton({
    super.key,
    required this.texto,
    required this.icono,
    required this.onPressed,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    final habilitado = onPressed != null && !cargando;

    return Container(
      decoration: BoxDecoration(
        gradient: TecomnetTheme.degradadoAccion,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: TecomnetTheme.azulClaro.withValues(
              alpha: habilitado ? 0.38 : 0.15,
            ),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: habilitado ? onPressed : null,
          child: SizedBox(
            height: 54,
            child: Center(
              child: cargando
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icono, color: Colors.white, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          texto,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Enlace de texto, en cian o gris según su peso en la pantalla.
class TecomnetLink extends StatelessWidget {
  final String texto;
  final VoidCallback onTap;
  final bool destacado;
  final TextAlign alineacion;

  const TecomnetLink({
    super.key,
    required this.texto,
    required this.onTap,
    this.destacado = false,
    this.alineacion = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          texto,
          textAlign: alineacion,
          style: TextStyle(
            color: destacado
                ? TecomnetTheme.cian
                : TecomnetTheme.textoSecundario,
            fontSize: 13.5,
            fontWeight: destacado ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

/// Muestra un aviso flotante con el estilo del portal.
void showNotice(
  BuildContext context,
  String mensaje, {
  Color color = TecomnetTheme.error,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
